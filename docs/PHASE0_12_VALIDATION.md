# Phase 0.12 - SQLite Regression Tests

This incremental package adds `tests/test_phase012_storage_contracts.py` to the repository.

## Installation

Copy the test file to `<repository-root>/tests/`. Do not overwrite existing project files. Keep your current Phase 0.11 fixes, localization fallbacks, GitHub Actions changes, and Linux FFI configuration.

## Execution

From the repository root:

```sh
python3 -m unittest discover -s tests -v
python3 scripts/check_sql_schema.py
python3 scripts/check_localizations.py
cd apps/mobile
flutter analyze
flutter test
```

## Coverage

Five in-memory SQLite contract tests cover:

- Deck rename retaining scheduling state
- Deletion of cards, notes, and review events belonging to a removed deck
- Retention of notes shared by cards in other decks
- Blocking parent-deck deletion while child decks exist
- Selecting and reversing the latest active review using persisted history

These tests intentionally work with a fresh in-memory SQLite database and never read or modify the user's application database.

## Limits

The tests validate SQL schema behavior and a mirror of intended data operations. They do not invoke Dart Drift methods, Flutter widgets, or the Rust FSRS engine, and are not end-to-end tests. Test coverage of actual Dart methods requires a Flutter integration-test harness with a temporary database. The existing FSRS learning/relearning scheduling limitation remains open.
