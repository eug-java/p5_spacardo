# Public Repository and Licensing Release Gate

Status: APPROVED as a repository hygiene policy; final original-source license is pending.

## Before first public push
- Choose the copyright owner and source license; add a correct top-level `LICENSE` file.
- Review licenses and attribution requirements for all direct/transitive dependencies and distributed binary assets.
- Keep copied Anki AGPL source and official branding outside this repository unless explicitly cleared and compliant.
- Remove credentials, build signing keys, user backups, private notes, personal identifying information and licensed fixture data.
- Pin dependency/tool versions and run the full test/documentation checks.
- Use meaningful English descriptions for issues, PRs and code comments; move translations to locale resource files.
- Create a `NOTICE`/`THIRD_PARTY_NOTICES` file when the chosen license/dependencies require it.
- Include `CONTRIBUTING.md`, `SECURITY.md`, and privacy/release documentation in English.

## Licensing recommendation
Apache License 2.0 is a strong candidate for this independent implementation due to explicit patent terms, clear attribution requirements and broad reuse rights. MIT is also permissive and simpler. This document does not choose a license on behalf of the project owner.

## Branding
A public repository name can be provisional. Final app display names, bundle identifiers, domains and graphic assets must await trademark and marketplace clearance. See `NAME_CLEARANCE.md`.
