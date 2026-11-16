# import

Read docs/replace-cloudingo.md. Identify the object, filter scope, group export and source-record export. Run the exact import with --dry-run first, show counts and reconcile them. Then import the agreed files. Never claim group IDs contain field values.

Read docs/cli.md for arguments. Use `node scripts/dedupe.mjs import` with the required arguments, prefer --json for analysis. Mutations require the operator's --by label. Resolve ambiguous names by showing candidates; never guess. Use the command result as evidence and explain any failure.
