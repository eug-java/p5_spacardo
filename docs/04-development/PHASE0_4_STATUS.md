# Phase 0.4 - Provisional scheduling and reversible reviews

## Implemented

- Due-only retrieval in the existing deck practice query.
- Atomic state update plus review event insertion.
- Idempotency by operation ID, with collision checking.
- Undo of the last non-undone review for a card (including state restoration).
- A temporary interval policy: Again 1 minute, Hard 1 day, Good 3 days, Easy 7 days.
- An explicit warning in the UI that this is not FSRS.

## Not implemented

- Native Flutter-to-Rust bridge; FSRS is NOT connected to the study UI.
- FSRS stability/difficulty state updates, learning steps, desired retention presets.
- Complete APKG parsing, import/export or production Web runtime verification.
- Undo persistence across app restart in the UI (the journal itself persists).

## Important limitations

The temporary interval policy must be removed when the Rust FSRS integration is verified. Do not represent this build as containing an operational FSRS scheduler. This stage uses schema-level SQLite regression tests only, not compiled Flutter/Rust tests.

## Local verification

Run `python3 -m unittest discover -s tests -v`, `python3 scripts/check_sql_schema.py`, and the existing localization/documentation checks. Then run `flutter analyze` and `flutter test` on a machine with Flutter installed.
