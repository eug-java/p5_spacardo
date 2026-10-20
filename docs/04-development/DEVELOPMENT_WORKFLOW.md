# Development Workflow

Status: APPROVED process, implementation still Phase 0.

## Branches and pull requests
- `main` contains reviewable, documented changes; work occurs in short feature branches.
- Every PR includes description, linked requirements/issue, tests, screenshots when UI changes, and a risk/rollback note.
- Require CI checks for Python, Dart/Flutter, Rust, documentation language, and dependency/license checks once those pipelines are available.
- Contributors must never add generated binaries, credentials, proprietary test decks, user data, or third-party content without permission.
- Reproducibility: pin SDK versions in toolchain config and commit relevant lock files.

## Documentation gate
Update PRD, affected ADR, architecture/data/schema documents, integration fixtures, and user instructions in the same PR. Maintain English for all repository documentation. Localized UI lives in ARB or equivalent locale catalogs.

## Release discipline
- Categorize releases as Technical Spike / Alpha / Beta / Stable with honest feature status.
- Confirm tested platform/OS/browser ranges and supported Anki package variants.
- Produce changelog, SBOM or dependency inventory, notices, signed artifacts, and integrity hashes as appropriate.
- Document migration, rollback limitations, backup and restore instructions.

## Required review topics
Code correctness, data loss, malicious imports, licensing/provenance, platform permissions, local/offline behavior, privacy statements, accessibility, and failure recovery.
