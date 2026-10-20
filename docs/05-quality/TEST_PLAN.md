# Test and Acceptance Plan

Status: PROPOSED.

## Test layers
- Rust unit/property tests for deterministic FSRS vectors, package header parsing, bounds and corruption cases.
- Dart unit tests for use cases; Drift integration tests for migrations, foreign keys, atomic reviews, and backup rollback.
- Flutter widget/golden tests for accessibility, light/dark mode, different viewport sizes and keyboard navigation.
- End-to-end Android, iOS, and Web tests for decks, reviews, import, export and recovery.
- Anki Desktop compatibility tests using independent clean profiles and known fixtures.
- Security/fuzz testing of ZIP, SQLite, templates, media and path normalization.

## Core acceptance cases
1. A fresh install creates a basic note, two reversible cards, reviews them, restarts, and retains state.
2. Every rating is applied once; duplicate operation UUID does not create another review event.
3. Undo restores the previous schedule without losing its cancellation audit record.
4. Failed APKG import leaves active records and files unchanged.
5. COLPKG restore creates verified backup before replacement.
6. Exact selected Anki Desktop release opens exported packages with expected record counts.
7. Two browser tabs cannot race migration/write operations.
8. Browser storage eviction and low-quota cases show actionable export/backup warnings.
9. Offline studies on Android, iOS and cached Web work without network requests for core operations.
10. Localization and screen readers expose every study rating and action.

## Evidence
Attach toolchain versions, target device/browser matrix, fixture SHA-256, logs/screenshots and expected-vs-observed data. Label each test `NOT RUN`, `PASS`, `FAIL`, or `BLOCKED`. No inferred pass status.
