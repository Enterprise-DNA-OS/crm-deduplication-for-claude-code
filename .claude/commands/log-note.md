# log-note

Run log-note and present the records the operator asked for.

Read docs/cli.md for arguments. Use `node scripts/dedupe.mjs log-note` with the required arguments, prefer --json for analysis. Mutations require the operator's --by label. Resolve ambiguous names by showing candidates; never guess. Use the command result as evidence and explain any failure.
