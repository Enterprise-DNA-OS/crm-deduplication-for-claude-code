create function touch_updated() returns trigger language plpgsql as $$ begin new.updated_at=now(); return new; end $$;
create function immutable_evidence() returns trigger language plpgsql as $$ begin raise exception 'Append-only evidence'; end $$;
create table workspace (id uuid primary key default gen_random_uuid(), name text not null, demo boolean not null default false, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create unique index one_workspace on workspace ((true));
create table records (
 id uuid primary key default gen_random_uuid(), external_id text not null unique, object_type text not null check(object_type in ('Contact','Lead','Account')), name text not null,
 fields jsonb not null default '{}', owner text not null default '', protected boolean not null default false,
 version integer not null default 1, verified_on date, review_on date,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table record_versions (id uuid primary key default gen_random_uuid(), record_id uuid not null references records, version integer not null, snapshot jsonb not null, actor text not null, created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(record_id,version));
create table duplicate_groups (
 id uuid primary key default gen_random_uuid(), code text not null unique, name text not null, origin text not null, object_type text not null check(object_type in ('Contact','Lead','Account')),
 owner text not null default '', due_on date, status text not null default 'open' check(status in ('open','proposed','applied','keep-separate')),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table members (id uuid primary key default gen_random_uuid(), group_id uuid not null references duplicate_groups, external_id text not null, created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(group_id,external_id));
create table proposals (
 id uuid primary key default gen_random_uuid(), group_id uuid not null references duplicate_groups, master_id text not null, values jsonb not null, provenance jsonb not null,
 versions jsonb not null, reason text not null check(length(trim(reason))>0), actor text not null, state text not null default 'proposed' check(state in ('proposed','applied','reversed','superseded')),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create unique index one_current_proposal on proposals(group_id) where state in ('proposed','applied');
create table notes (id uuid primary key default gen_random_uuid(), group_id uuid not null references duplicate_groups, body text not null, actor text not null, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create table import_batches (id uuid primary key default gen_random_uuid(), digest text not null unique, filename text not null, records_added integer not null, records_updated integer not null, groups_added integer not null, actor text not null, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create table history (id uuid primary key default gen_random_uuid(), action text not null, entity_id uuid, actor text not null, detail jsonb not null, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
do $$ declare t text; begin
 foreach t in array array['workspace','records','record_versions','duplicate_groups','members','proposals','notes','import_batches','history'] loop
 execute format('create trigger touch before update on %I for each row execute function touch_updated()',t);
 execute format('alter table %I enable row level security',t);
 execute format('revoke all on %I from public',t);
 end loop;
 foreach t in array array['record_versions','members','notes','import_batches','history'] loop
 execute format('create trigger evidence before update or delete on %I for each row execute function immutable_evidence()',t);
 end loop;
end $$;
create view v_group_review as
 select g.id,g.code,g.name,g.object_type,g.owner,g.due_on,g.status,count(m.id)::int as members,
 count(m.id) filter(where r.id is null)::int as missing_records,
 count(m.id) filter(where r.protected)::int as protected_records,
 case when g.status in ('applied','keep-separate') then 'closed' when g.due_on<current_date then 'overdue' when g.owner='' then 'unassigned' else 'scheduled' end as attention
 from duplicate_groups g left join members m on m.group_id=g.id left join records r on r.external_id=m.external_id group by g.id;
create view v_conflicts as
 select g.code,g.name,k.key as field,count(distinct k.value)::int as different_values
 from duplicate_groups g join members m on m.group_id=g.id join records r on r.external_id=m.external_id
 cross join lateral jsonb_each_text(r.fields) k
 where k.value<>'' and g.status in ('open','proposed')
 group by g.code,g.name,k.key having count(distinct k.value)>1;
create view v_coverage as select g.code,g.name,m.external_id,r.name as record_name,r.owner,r.version,r.protected,r.verified_on,r.review_on,
 case when r.id is null then 'missing source record' when r.verified_on is null then 'accuracy not checked' when r.review_on is null then 'retention review not set' when r.review_on<current_date then 'retention review overdue' else 'review recorded' end as finding
 from duplicate_groups g join members m on g.id=m.group_id left join records r on r.external_id=m.external_id;
create view v_canonical as
 select p.id,p.group_id,g.code,p.master_id,p.values,p.provenance,p.created_at,
 exists(select 1 from members m join records r on r.external_id=m.external_id where m.group_id=p.group_id and (p.versions->>r.external_id)::int<>r.version) as stale
 from proposals p join duplicate_groups g on g.id=p.group_id where p.state='applied';
create view v_owner_workload as select owner,count(*)::int as groups,count(*) filter(where attention='overdue')::int as overdue,sum(missing_records)::int as missing_records from v_group_review where status in ('open','proposed') group by owner;
create view v_compliance as
 select 'ACCURACY'::text as rule, external_id as record, 'Record the accuracy check before use'::text as finding,'https://www.privacy.org.nz/privacy-principles/8/'::text as source from records where verified_on is null
 union all select 'RETENTION',external_id,'Set or complete the business retention review','https://www.privacy.org.nz/privacy-principles/9/' from records where review_on is null or review_on<current_date
 union all select 'PROTECTED',g.code,'Protected member needs individual review before consolidation','https://www.privacy.org.nz/privacy-principles/7/' from v_group_review g where protected_records>0 and status in ('open','proposed')
 union all select 'SOURCE',g.code,'Obtain missing source field values before a decision','https://www.privacy.org.nz/privacy-principles/8/' from v_group_review g where missing_records>0
 union all select 'STALE',code,'Source records changed after this local consolidation','https://www.privacy.org.nz/privacy-principles/8/' from v_canonical where stale;
revoke all on v_group_review,v_conflicts,v_coverage,v_canonical,v_owner_workload,v_compliance from public;
