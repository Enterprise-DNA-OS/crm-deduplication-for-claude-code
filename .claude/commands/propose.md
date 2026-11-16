# propose

Read show-group and conflicts first. Confirm that the records refer to the same entity. Require an exact master external ID and a reason. Put explicit field source choices in a local JSON file if needed. Show the values and provenance returned. Never infer identity solely from matching text.

Read docs/cli.md for arguments. Use `node scripts/dedupe.mjs propose` with the required arguments, prefer --json for analysis. Mutations require the operator's --by label. Resolve ambiguous names by showing candidates; never guess. Use the command result as evidence and explain any failure.
