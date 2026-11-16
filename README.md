# CRM Deduplication for Claude Code

Own your duplicate review queue, field choices and decision history. Bring Cloudingo group exports and source records into a database, then ask Claude Code, Codex, OpenCode or Cursor to do the review work. MIT licensed.

## Three ways to use it

- **Do it yourself:** install the free version, import your exports, and operate the local duplicate review desk. Hosting and your coding-agent subscription remain your costs.
- **We customise it:** Enterprise DNA maps your fields and matching rules, brings your Cloudingo data across, and builds a web front end or different stack when you need one.
- **We run it for you:** Omni by Enterprise DNA installs, connects and operates your version. One setup fee, then a retainer. [Book a 30-minute call](https://enterprisedna.co/omni/book/?offer=replace-software&utm_campaign=cloudingo&utm_medium=readme).

## Try fictional records

```bash
npm install
npm test
npm run demo
```

The demo uses a temporary database and removes it afterwards. `npm run demo -- --keep` keeps the HTML and actual command captures in the printed temporary folder. It never seeds your business database. Node 22 or later is required.

## Start your review desk

```bash
npm run migrate
node scripts/dedupe.mjs init --name="Your business" --by="Your name"
node scripts/dedupe.mjs import cloudingo examples/cloudingo-contact-groups.csv --object=Contact --scope="Example" --records=examples/contacts.csv --by="Your name" --dry-run
```

Replace the example paths with your own exports after reading [the switching guide](docs/replace-cloudingo.md). Cloudingo's basic export contains groups and record IDs, not field values. The guide explains the second source file, column mapping and count reconciliation.

DATABASE_URL selects a private Postgres database. Otherwise DATA_DIR selects embedded PGlite, defaulting to `.data/db`. OUTPUT_DIR chooses where private reports and archives are written. Use one business and one trusted operator per workspace. Operator labels are not authentication. Do not expose the database owner's connection through a browser.

## The five weekly jobs

1. `/attention`: assign overdue and unowned duplicate groups.
2. `/coverage`: obtain missing field values and record accuracy checks.
3. `/conflicts`: compare disagreements before choosing a master.
4. `/propose` then `/apply`: record field sources and consolidate locally.
5. `/weekly-review`: check the queue, conflicts and workload, then prepare a handover.

There are 28 CLI operations. [Full syntax](docs/cli.md). The same recipes live under `.claude/commands/`, and AGENTS.md points other coding agents to them. `/compliance` lists recorded checks with source links. `/undo` reverses a local consolidation and keeps its evidence.

A proposal cannot apply if source versions changed, a member is protected or another applied group already contains a member. Any true email opt-out survives; unknown preferences remain unknown unless all records explicitly say false. Source values and their versions remain available after consolidation. No operation sends messages, deletes source records or changes Salesforce.

## Documents and views

Set `brand.json` to your business name, logo and colours. `npm run docs` renders a decision pack per group and an accuracy review. `npm run view` renders the week, conflicts and compliance findings as read-only HTML. `/draft-review` writes a private review draft. `/new-view` adds a report from a question. [Why no front end](docs/why-no-front-end.md).

## Ten questions answered from your records

`/insights` answers these today. They are included queries, not a claim that Cloudingo cannot be configured to answer them.

1. Which open groups contain records whose details are missing?
2. Which overdue groups have no reviewer?
3. Which duplicate groups contain conflicting email preferences?
4. Which people appear in more than one open group?
5. Which groups disagree about the email address?
6. Which owners have overdue work and missing source records?
7. Which protected records are awaiting a duplicate decision?
8. Which local consolidations became stale after a fresh export?
9. Which records have an overdue retention review?
10. Which decisions were reversed and why?

## Your first hour: ten things to ask for

1. Show the groups nobody owns.
2. List the groups missing source details.
3. Compare every field in the Taylor group.
4. Assign the group to our data steward.
5. Protect a record with an open correction request.
6. Keep the opt-out when choosing the survivor.
7. Draft the decision pack in our business name.
8. Show decisions affected by a fresh export.
9. Add a read-only view of work by region.
10. Use `/customise` to add our region field with a migration and import test.

## Limits to plan around

This base uses Contact, Lead and Account export snapshots and exact email plus surname matching. It does not perform fuzzy identity matching, email deliverability checks, cross-object conversion, live duplicate prevention or Salesforce merging. It does not carry related activities, attachments or custom object automation. Applying and undoing here affect local canonical records only. Live Salesforce connections require separate development and cutover tests.

New export values replace the working snapshot and create history; old exports can roll it back, so import dated exports in order. Changed group membership requires a new scope. Reconcile files before making decisions. No enterprise-volume performance benchmark is claimed. JSON export is a readable archive, not a restore utility. Database administrators can bypass application controls. Keep private exports, tested database backups and a business retention process.

[Compliance basis](docs/compliance.md) · [Research](docs/research.md) · [Verification](docs/verification.md)
