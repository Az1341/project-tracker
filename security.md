# security.md — Public Project Tracker

**Classification:** Non-authoritative control-review guide. **Status:** DRAFT / NOT CERTIFIED, 12 October 2026 (Europe/London). This document neither certifies existing controls nor authorises new security tests or production changes.

## Source of authority
No confirmed canonical SOT or current deployed application. Repository is public. If there is a conflict, reconcile the authoritative implementation and approved decisions; do not elevate this summary to a second Source of Truth.

## Priority threats to review
- Accidental exposure of private portfolio project plans or account identifiers.
- Creating false authentication or live-app policy where none is verified.

## Security boundaries to preserve
- Confirm ownership, application purpose and intended repository visibility.
- No personal, private business, financial or credential data in public commits.
- Only GitHub least-privilege reviews until actual runtime boundaries are known.

## Evidence and incident treatment
- Collect reproducible scoped findings and exact commit SHA using synthetic or redacted evidence. No live penetration test authorised by this file.
- Never include API keys, tokens, personal records or exploit artefacts with real data in repository documentation.
- For exposure or a serious finding, preserve evidence, restrict access and use established incident/credential-response procedures with the appropriate owner.
- Verify a fix in isolation; an unrun check is **NOT RUN**, never PASS.

**Release decision:** HOLD. Do not merge until ownership and scope are confirmed.

Related: [auth.md](auth.md), [data.md](data.md), [hack.md](hack.md), [checklist.md](checklist.md).
