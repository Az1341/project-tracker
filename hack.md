# hack.md — Authorised defensive assessment: project-tracker

**Status:** DRAFT scope statement, 12 October 2026 (Europe/London). The filename is a checklist label only; it is **not** authorisation to hack, penetrate, scan or attack systems.

## Assessment target
scope verification and public information disclosure.

## Allowed review
Inspect public repository metadata and source for inappropriate private project details, credentials, and unexpected publication paths. Identify the owner before naming an application attack surface.

## Explicitly prohibited
No attempts against unknown services, private portfolio systems or third-party accounts.

## Required safeguards and evidence
1. Confirm owner, approved environment, test identity, exact code revision and stop conditions before any active test. A documentation review alone is not active-test approval.
2. Prefer static source and dependency review. Use synthetic fixtures and offline deterministic test execution only where authorised and accessible; never fabricate runtime output.
3. Capture finding ID, severity, verified code line or observed test result, remediation, retest outcome, and reviewer. Label missing tests **NOT RUN**.
4. Stop if real secrets or personal data are discovered, preserve minimal redacted evidence and escalate privately according to existing policy.
5. Fix any verified issues via a separate scoped change when code changes are required. This documentation-only PR is not a vulnerability-remediation branch.

No project access, vendor key, deployment, destructive activity or production testing is conferred by this file. Existing approved policies take precedence.

See [security.md](security.md), [auth.md](auth.md), [data.md](data.md) and [checklist.md](checklist.md).
