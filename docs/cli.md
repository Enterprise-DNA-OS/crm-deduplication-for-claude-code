# Command reference

Run `node scripts/dedupe.mjs <command>`. Every command accepts `--json`. Flags use `--key=value`; quote values with spaces. Dates are real calendar dates in YYYY-MM-DD form. Mutations require `--by="Reviewer name"` and record that label in history. This is a trusted operator label, not authentication.

| Command | Arguments and effect |
|---|---|
| help | List the 28 operations |
| init | `--name="Business" --by="Name"`; initialise one empty business workspace |
| import | `cloudingo groups.csv --object=Contact --scope="Filter name and export period" --records=contacts.csv --by="Name"`; optional `--dry-run` and `--map=examples/column-map.json` |
| add-record | `--id=LOCAL-1 --object=Contact --name="Person" --email=person@example.test --last-name=Person --owner=Name --by=Name`; add a local record |
| records | Source identities, versions, owners and review dates |
| groups | All duplicate groups with member counts and missing evidence |
| show-group | `<code-or-id-or-name>`; complete members, proposals and notes |
| scan | `--by=Name`; propose groups with matching nonblank email and surname, within Contact or Lead |
| assign | `<group> --owner=Name --due=2026-12-01 --by=Name` |
| propose | `<group> --master=EXACT-EXTERNAL-ID --reason="Evidence" --by=Name`; optional `--fields=choices.json` selects a source member per field |
| apply | `<group> --by=Name`; apply the current proposal to the local canonical view only |
| undo | `<group> --reason="Why" --by=Name`; reverse a local consolidation and reopen |
| keep-separate | `<group> --reason="Why" --by=Name`; record that the group must not consolidate |
| reopen | `<group> --reason="Why" --by=Name`; reopen a keep-separate group |
| protect | `<record> --value=true --reason="Why" --by=Name`; false releases the protection |
| verify-record | `<record> --verified=2026-11-16 --review=2027-02-16 --by=Name`; record a completed accuracy check and next business retention review |
| log-note | `<group> --text="Evidence or correction statement" --by=Name` |
| attention | Open review work, overdue and unassigned |
| coverage | Missing source records, accuracy and retention review status |
| conflicts | Fields with different nonempty values in open groups |
| owners | Open group counts, overdue work and missing evidence by reviewer |
| canonical | Local applied consolidations, provenance and stale flag |
| history | Actor-labelled actions and decision evidence |
| compliance | Recorded accuracy, retention, protection and source findings |
| insights | All ten joined questions, or `--question=1` through `--question=10` |
| export | JSON archive of records, versions, groups, proposals and history |
| draft-review | `<group>`; private branded HTML decision draft |

The record and group selectors accept exact external IDs/codes, UUID prefixes or case-insensitive names. Exact identifiers win. Ambiguous selectors print candidates and exit 1. A master or field source requires an exact member external ID.

Proposal defaults retain the selected master's fields. A choices file maps field names such as `Phone` to a member external ID. No empty value is filled from another record without that choice. Email opt-out combines conservatively: any true remains true, all false becomes false, otherwise unknown remains unknown. This is a data-preservation rule, not permission to send marketing.

An import validates the complete group file, then writes source changes and groups atomically. Identical batches do nothing. Fresh field values increment record versions and clear the previous accuracy check. Changed membership under the same scope fails; use a new export scope and review the new group. An old applied group blocks overlapping consolidations until reversed. Re-importing an old export can restore old source fields: use dated, reconciled exports in order.

All mutations use one transaction and an advisory lock. Original source values remain in version history when a local consolidation is applied. New source versions mark applied decisions stale. No operation calls Salesforce, merges live records, changes owner assignments there, deletes records, sends messages or verifies email deliverability.
