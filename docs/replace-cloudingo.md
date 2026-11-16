# Moving the review desk from Cloudingo

## Export the groups

Cloudingo documents a pre-merge CSV export containing Group Name, Total Matches and an object-specific IDs column. IDs in that last column are comma-separated. It does not carry selected masters or field values. Enable Export Filter Results under Subscription, then choose Export from a dedupe filter and download the CSV. Professional and Enterprise can request the export add-on without another fee. [Vendor instructions](https://help.cloudingo.com/docs/reports-exportable-reports-pre-merge), checked 16 November 2026.

Export one object type and filter at a time. Supported objects are Contact, Lead and Account. Mixed-object, Person Account and custom-object groups need a separately written mapping. Keep the original files and reconcile group counts, member IDs and Total Matches before relying on the migration.

## Obtain field values

Supply a corresponding source CSV with Id and the fields you need. The standard adapter recognises FirstName, LastName, Email, Phone, Company, MailingCity, HasOptedOutOfEmail and Owner, Owner.Name or OwnerId. Name is used when present. Email preferences must be true, false or blank. Blank means unknown. This is the source record snapshot you obtained from Salesforce or a configured Cloudingo Find Data export; a basic pre-merge export alone cannot reconstruct it.

Cloudingo describes retrieving field data using Find Data after separating exported IDs. [Find Data](https://help.cloudingo.com/docs/tools-find-data). Check the actual output headers. Unknown custom fields are not mapped into the working record. Keep them in your original export, and add their mapping and tests before your cutover. Activity, attachments, relationships, automation rules, historical merges and credentials do not arrive in the basic group export.

The examples are fictional fixtures based on the documented column structure, not downloaded customer exports.

## Import in one command

Start an empty workspace with `npm run migrate` and `node scripts/dedupe.mjs init --name="Your business" --by="Your name"`. Then:

```bash
node scripts/dedupe.mjs import cloudingo exports/groups.csv --object=Contact --scope="Contact email filter 2026-11-16" --records=exports/contacts.csv --by="Your name" --dry-run
node scripts/dedupe.mjs import cloudingo exports/groups.csv --object=Contact --scope="Contact email filter 2026-11-16" --records=exports/contacts.csv --by="Your name"
```

Use an input folder other than the generated `exports/` archive folder if preferred. Add `--map=examples/column-map.json` when the group column labels differ. Without `--records`, the groups import for inventory but missing details block consolidation. A dry run validates and rolls back all writes.

## Reconcile and decide

Run `/groups`, `/coverage` and `/conflicts`. Compare every imported scope to the intended export. Assign a reviewer and due date, read both records, then propose a master and field sources. A duplicate suggestion is not proof that two people are the same person. Protected records, missing source fields, source changes and already-applied overlaps block consolidation. Record correction statements and conflicting preferences before deciding.

`apply` creates a local canonical record with field provenance. `undo` removes that local result from the active view and preserves the decision history. Neither changes Salesforce. If you need live Salesforce merging, conversion, related-record reassignment, scheduled jobs or undo in Salesforce, Enterprise DNA must build and test that connection against your object relationships and permissions before it replaces Cloudingo. Keep those existing operations running until the replacement has passed a controlled cutover.

The small base has no enterprise-volume performance claim. Try a representative export, review its timing and reconcile results. JSON export is an archive, not an automated restore process; keep database backups and original export files.
