# Verification

Local Linux run on 16 November 2026: npm install, npm test and npm run demo passed. The smoke suite exercises 28 CLI operations and 81 assertions, including import rollback, repeat imports, partial names, conflicting values, protected records, stale proposals, overlapping local consolidations, reversal, opt-out preservation, HTML escaping, archives, read-only reports and seed isolation.

The checked-in workflow runs npm ci, npm test and npm run demo on Linux and Windows. A separate job runs the smoke suite against disposable Postgres 17. Results will be recorded here after the private push.

Three actual demo command outputs feed the landing page. The fixtures and demo business are fictional. No customer data or live Salesforce connection was used. Source-format compatibility is based on the vendor's documented CSV structure; account-specific headers still need checking.
