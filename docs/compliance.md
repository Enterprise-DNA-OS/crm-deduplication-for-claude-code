# Accuracy and retention checks

These checks inspect recorded evidence. They do not determine identity, approve a legal basis, certify compliance or perform a live CRM correction. Sources checked 16 November 2026.

| Rule | Basis | What the software actually checks |
|---|---|---|
| ACCURACY | [NZ Privacy Act principle 8](https://www.privacy.org.nz/privacy-principles/8/) requires reasonable steps to check information before use or disclosure. | A source record without a recorded accuracy check is flagged. Fresh source values clear the check. A candidate match is never treated as proof. |
| SOURCE / STALE | Same principle 8. | Groups with missing source details and applied decisions whose source versions changed are listed. Application of an outdated proposal is blocked. |
| RETENTION | [NZ Privacy Act principle 9](https://www.privacy.org.nz/privacy-principles/9/) limits retention to the period needed for lawful purposes. | Missing or overdue business review dates are flagged. There is no statutory interval encoded and no automatic deletion. |
| PROTECTED | [NZ Privacy Act principle 7](https://www.privacy.org.nz/privacy-principles/7/) provides correction and attached-statement rights. | A protected source record blocks local consolidation. Notes preserve a statement supplied by the operator. The software does not itself fulfil a correction request or notify earlier recipients. |

A reviewer sets dates for the business and verifies the evidence. No fixed review interval is presented as law. Australian organisations must map their applicable privacy duties before use; these named checks cite New Zealand principles only.

Any true email opt-out is preserved across consolidation; unknown preferences do not turn into false. That policy reduces data loss, but is not a legal determination of permission to contact someone.

Use one business per database with a trusted operator. The local app uses its database owner role. Row-level access is not a multi-user permissions implementation. Restrict connection access, keep backups, and keep generated HTML, original exports and history private. History and source versions are append-only through triggers, but a database administrator can bypass those controls. A deliberate retention and backup process remains required.
