# Contributing

Thank you for helping build a free, private and accessible spaced repetition app for Android, iOS and Web.

## Before contributing
- Read the root README, PRD, architecture, documentation policy and security threat model.
- Discuss large behavioral changes in an issue/ADR before implementing them.
- Write documentation, pull requests, issue descriptions and public API comments in English.
- Keep user-facing localized strings in dedicated localization resources.
- Avoid dependencies with unreviewed licenses, especially Anki upstream AGPL code/assets.
- Do not commit copyrighted decks, private user information, tokens or keys.

## Development checklist
1. Fork/branch from the default branch and make one coherent change.
2. Update requirement IDs, ADRs, tests and user documentation in the same PR.
3. Run `python3 scripts/check_documentation_language.py` and relevant Python, Rust and Flutter tests.
4. Explain tested OS, browser/device, versions and any unverifiable assumptions.
5. Describe migration, rollback and data-loss implications when applicable.
6. Submit a clear PR with issue reference, test evidence, screenshots for UI changes and a license/provenance statement for new dependencies/assets.

A future Contributor License Agreement is **not** currently required or specified. Contribution licensing terms must be reviewed after choosing the repository's actual software license.
