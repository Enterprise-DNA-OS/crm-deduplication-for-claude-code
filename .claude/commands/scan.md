# scan

Run scan. The exact email and surname matches are candidates only. Report the new groups and require human identity review.

Read docs/cli.md for arguments. Use `node scripts/dedupe.mjs scan` with the required arguments, prefer --json for analysis. Mutations require the operator's --by label. Resolve ambiguous names by showing candidates; never guess. Use the command result as evidence and explain any failure.
