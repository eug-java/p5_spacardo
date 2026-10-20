# Security Policy

## Project status
This is a technical prototype. There are no supported stable product versions or guaranteed response deadlines.

## Reporting vulnerabilities
Do not publish proof-of-concept payloads, user data, vulnerable deck archives or exploit instructions in a public issue. Once a GitHub repository is created, enable and document GitHub's private vulnerability reporting or publish a verified security contact address. Until then, do not assume private reporting is configured.

## Main security boundaries
Treat imported Anki/ZIP/SQLite and embedded card templates as hostile. Maintain decompression limits, path validation, unprivileged rendering, transactional import, and no access to privileged application APIs from imported content. Never upload private decks or media in bug reports unless sanitized and explicitly authorized.

## Supported versions
None; Phase 0 is not production ready.
