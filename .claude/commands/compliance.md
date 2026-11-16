# compliance

Run compliance. Explain each finding using docs/compliance.md and its source. These are recorded checks, not legal certification.

Read docs/cli.md for arguments. Use `node scripts/dedupe.mjs compliance` with the required arguments, prefer --json for analysis. Mutations require the operator's --by label. Resolve ambiguous names by showing candidates; never guess. Use the command result as evidence and explain any failure.
