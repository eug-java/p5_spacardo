# Preliminary Legal Review - United States

Date: 2026-10-19. Status: DRAFT - NOT LEGAL ADVICE.
This engineering review is not a legal opinion or a guarantee of non-infringement. Obtain trademark clearance and license review before public release.

## High-level conclusion
Independently creating flashcard software with an FSRS scheduler and import/export of selected Anki package formats is generally a plausible lawful project. However, the legal outcome depends on actual copied code, trademarks, UI assets, bundled decks, third-party libraries, packaging and distribution practices.

## Restrictions and precautions
1. Do not copy, link, or redistribute AGPL-covered Anki code without a deliberate and fully compliant distribution decision.
2. Do not reuse original Anki icons, branding, screenshots, bundled examples, templates, documentation text or other creative assets without evaluating applicable rights/licenses.
3. Do not brand the application as Anki, AnkiMobile, AnkiPro, AnkiApp or imply official association with Ankitects.
4. Do not use OpenCards as a final product name: existing flashcard products use that name.
5. Do not distribute user-created/shared decks and media without adequate authorization.
6. Do not ship an unaudited executable JS surface within imported card templates.
7. Do not implement AnkiWeb access/scraping in MVP.

## Compatibility vs copied source
Interoperating with a publicly used file format and writing original codec code is distinct from copying protected implementation details. Maintain an independent design record, independently generated fixtures, provenance log, and strict code-review boundaries. Applicable rules can differ by jurisdiction, especially around reverse engineering.

## Dependency review (version-specific verification still required)
- Anki upstream repository: AGPL-3.0-or-later for core components; do not include its core by default.
- `fsrs-rs`: BSD-3-Clause; retain notices and check transitives.
- Flutter: BSD-3-Clause.
- Riverpod, Drift and flutter_rust_bridge: permissive licenses (verify at pinned releases).
- Icons, fonts, SQLite WASM distribution, codecs, compressors, and all direct/transitive dependencies require individual checks.

## Public repository licensing
Public availability on GitHub does not grant others unrestricted rights to modify or distribute the code. A complete top-level LICENSE and third-party notices are required to make clear permissions. Recommend Apache-2.0 for original code, subject to owner decision and dependency review. Do not publish a license placeholder as though it were final. Open sourcing our own code also does not automatically satisfy AGPL obligations if AGPL code is later included.

## Trademark and naming
Trademark search must include the USPTO live/pending records, similar spellings, relevant mobile apps, software/web services, GitHub, web domains and regional registrations where distribution is expected. A free domain does not establish trademark clearance. Avoid similar icons and unsubstantiated affiliations. Suggested factual disclosure: `Supports importing and exporting selected Anki package formats (.apkg/.colpkg). Not affiliated with or endorsed by Ankitects Pty Ltd.`

## Privacy, platform compliance and content
User data remains local in MVP, but web host/CDN can process IP addresses, access times and URLs. App stores have separate privacy, software/IP, account and submission rules. Independently authored sample decks and images are preferred; do not redistribute AnkiWeb content without its applicable license/permissions.

## Before release
- [ ] Product name cleared with relevant trademark review.
- [ ] Chosen source license included; direct/transitive notices generated.
- [ ] No unintended AGPL/copyleft dependencies or copied Anki source/assets.
- [ ] Store listing and screenshots contain no misleading association.
- [ ] Privacy policy reflects actual network requests and host logging.
- [ ] Independent Anki round-trip compatibility documented.
- [ ] Sample content provenance and permissions documented.

Sources: https://github.com/ankitects/anki ; https://tmsearch.uspto.gov/ ; https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository
