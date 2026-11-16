do $$
declare g uuid;
begin
 if exists(select 1 from workspace) then
  if not exists(select 1 from workspace where demo) then raise exception 'Refusing to seed a business workspace'; end if;
  return;
 end if;
 if exists(select 1 from records) then raise exception 'Refusing nonempty workspace'; end if;
 insert into workspace(name,demo) values('Harbour Supply Demo',true);
 insert into records(external_id,object_type,name,fields,owner,verified_on,review_on) values
 ('003DEMO000000001','Contact','Mere Wilson','{"FirstName":"Mere","LastName":"Wilson","Email":"mere@example.test","Phone":"021000001","Company":"Harbour Supplies","HasOptedOutOfEmail":false}','Aroha',current_date-90,current_date-1),
 ('003DEMO000000002','Contact','Mere Wilson','{"FirstName":"Mere","LastName":"Wilson","Email":"MERE@example.test","Phone":"021000002","Company":"Harbour Supplies","HasOptedOutOfEmail":true}','James',null,null),
 ('003DEMO000000003','Contact','Chris Ng','{"FirstName":"Chris","LastName":"Ng","Email":"chris@example.test","Phone":"021000003","Company":"Southern Parts","HasOptedOutOfEmail":false}','Aroha',current_date,current_date+90),
 ('003DEMO000000004','Contact','Chris Ng','{"FirstName":"Chris","LastName":"Ng","Email":"chris@example.test","Phone":"021000004","Company":"Southern Parts","HasOptedOutOfEmail":null}','James',null,current_date+10),
 ('003DEMO000000005','Contact','Riley Stone','{"FirstName":"Riley","LastName":"Stone","Email":"riley@example.test","Company":"Inlet Distribution","HasOptedOutOfEmail":false}','',null,null);
 update records set protected=true where external_id='003DEMO000000004';
 insert into record_versions(record_id,version,snapshot,actor) select id,version,to_jsonb(r),'demo seed' from records r;
 insert into duplicate_groups(code,name,origin,object_type,owner,due_on) values('DUP-101','Mere Wilson duplicate','demo','Contact','Aroha',current_date-3) returning id into g;
 insert into members(group_id,external_id) values(g,'003DEMO000000001'),(g,'003DEMO000000002');
 insert into notes(group_id,body,actor) values(g,'Confirm the phone number with the account owner. Do not remove the opt-out.','Aroha');
 insert into duplicate_groups(code,name,origin,object_type,owner,due_on) values('DUP-102','Chris Ng review','demo','Contact','James',current_date+2) returning id into g;
 insert into members(group_id,external_id) values(g,'003DEMO000000003'),(g,'003DEMO000000004');
 insert into duplicate_groups(code,name,origin,object_type,owner,due_on) values('DUP-103','Riley Stone missing detail','demo','Contact','',current_date-1) returning id into g;
 insert into members(group_id,external_id) values(g,'003DEMO000000005'),(g,'003DEMO000000006');
 insert into history(action,actor,detail) values('seed','demo seed','{"fictional":true}');
end $$;
