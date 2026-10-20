# Product Requirements - Cross-platform SRS MVP

Version: 0.2. Status: PROPOSED. Product name: unapproved working codename.

## Vision
A free, ad-free, privacy-focused flashcard study application sharing core behavior across Android, iOS, and Web/PWA. No account or application backend is required. Users retain ownership of their learning records and can import/export selected Anki package formats. Do not claim complete Anki compatibility until validated.

## User
One local user per app installation/browser origin. Future multi-device synchronization is out of MVP scope. Internal stable UUIDs and event records anticipate that future work.

## Functional requirements and acceptance
| ID | Requirement | Acceptance criterion |
| --- | --- | --- |
| FR-001 | Create, rename, nest, and delete decks | State persists; destructive deletion requires confirmation |
| FR-002 | Basic, Reversed, and Cloze note models | Deterministic generation of the expected cards |
| FR-003 | Edit notes, fields, tags, and templates | Field validation and preview work on all platforms |
| FR-004 | Study session | Reveal, Again/Hard/Good/Easy, due queue, suspend |
| FR-005 | FSRS scheduling | Native and Web WASM produce matching golden test vectors |
| FR-006 | Review history and undo | Single atomic review event; repeated operation ID is idempotent |
| FR-007 | Import APKG | Inspect, preview, merge safely, report successes and warnings |
| FR-008 | Restore COLPKG | Validate, create backup, replace atomically, recover from failure |
| FR-009 | Export APKG/COLPKG | Test target version of Anki Desktop imports valid output |
| FR-010 | Media | Safe local images and audio with portable references |
| FR-011 | Statistics | Daily reviews, history summaries, next-30-day forecast |
| FR-012 | Search | Filter cards/notes by text, deck, and tags |
| FR-013 | Backup/restore | File-based backup with integrity checks |
| FR-014 | Offline operation | Fully local after installation / PWA assets are cached |
| FR-015 | Localization | UI strings support English and Russian resource catalogs |
| FR-016 | Privacy | No advertising SDK, tracking, or mandatory telemetry |

## Exclusions
No AnkiWeb integration; no automated cloud, LAN, or peer-to-peer sync; no paid services or AI subscriptions; no speech recognition, OCR/PDF ingestion, shared-deck catalog, plugins, untrusted executable card JavaScript, or collaboration during MVP.

## Platform requirements
- Proposed Android minimum API 26; proposed iOS minimum 15; browser support established by test matrix, not assumed.
- Same domain model and algorithms across platforms, with platform-specific file pickers, storage, accessible layouts, and permissions.
- Web stores user data in SQLite WASM/OPFS or IndexedDB and must warn about possible browser eviction.
- Long operations must not block UI; failed imports must not corrupt the active collection.
- Imports/exports with known limitations must visibly warn before completion.

## Phase 0 exit criteria
1. Native Android/iOS and Web Flutter bootstraps are reproducible on pinned toolchains.
2. Rust FSRS matches a common golden dataset on native targets and WASM.
3. SQLite persists data on mobile and across browser reloads where supported.
4. A representative APKG is decoded, then exported and imported by real Anki Desktop.
5. Supported Anki version/feature matrix and import size limitations are recorded.
6. License and asset audits pass; no unexpected AGPL-covered Anki code is included.

## Definition of done
Implementation, automated tests, device/browser evidence, English documentation, migration notes (if applicable), accessibility, error-handling tests, and reviewed licensing are required for each release-ready feature. Phase 0 is a technical spike, not a shipped MVP.
