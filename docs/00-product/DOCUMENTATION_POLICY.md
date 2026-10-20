# Documentation Policy

Status: APPROVED for repository contributions. Language: English only.

## Scope
All public documentation must be written in English: README, architecture decision records (ADRs), product and technical specifications, setup/runbooks, code and API comments, pull requests, issues, release notes, user guides, and contributor-facing templates. The application may provide localized UI strings; translations belong in localization resources, not in the documentation. Third-party material may be quoted in its original language only where required and accompanied by English explanation and licensing metadata.

## Docs as code
- Maintain Markdown documentation in the same public Git repository as the implementation.
- Any change in functional behavior must update the applicable requirement, tests, user instructions, and changelog in the same pull request.
- Every document identifies status (DRAFT, PROPOSED, APPROVED, IMPLEMENTED, or VERIFIED), owner or responsible role, revision date, and related ADR/issue when applicable.
- Document prerequisites, exact steps/commands, expected result, troubleshooting, and recovery/rollback. Flag commands that have not been validated.
- Distinguish implemented/verified behavior from target specifications; never present placeholders or examples as shipped functionality.
- Record test evidence and environment (operating system, dependencies, devices, toolchain version).
- Maintain dependency license/provenance inventory and an explicit compatibility matrix for Anki package variants.
- Never commit copyrighted third-party decks, media, icons, or sample content without documented permission.

## Review checklist
- [ ] Public text and comments are in English.
- [ ] Applicable requirement IDs and acceptance criteria are updated.
- [ ] Architecture decisions have an ADR where needed.
- [ ] Platform-specific differences across Android, iOS, and Web are described.
- [ ] Happy path and failure/rollback behavior are documented.
- [ ] Any new dependency has a known license and provenance.
- [ ] CI/test evidence supports verification statements.
- [ ] Trademark and privacy claims have been reviewed.

## Enforcement
Run `python3 scripts/check_documentation_language.py` and the documentation CI workflow. This lightweight check detects Cyrillic characters in Markdown and selected metadata; it cannot prove that text is grammatical English or that content is legally cleared. Human review remains required.
