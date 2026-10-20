# Phase 0.3 - Local Practice Slice

## Scope

This phase introduces persisted Basic notes and cards, a deck selection flow, and append-only practice feedback events. It does **not** implement FSRS interval calculation or rescheduling.

## Data flow

1. Create a deck on Home.
2. Tap the deck to open Practice.
3. Add a Basic card with front and back text.
4. Reveal the answer and choose Again, Hard, Good, or Easy.
5. A review event is stored with a unique operation ID and unchanged before/after card states.
6. Reopen the application to check that decks/cards still exist; saved feedback is stored in `review_events`.

## Limitations

- This is a source-level prototype; it has not been compiled with Flutter or Rust in the current environment.
- Ratings do not set due dates; the scheduler integration is a release blocker.
- Cards are plain text in this phase; Anki HTML sanitization and media rendering are pending.
- ARB keys introduced in this phase have English fallback text in all 18 locale files, pending human translation.
- Web requires `sqlite3.wasm` and `drift_worker.js` artifacts as described in the previous runbook.
- Import/export Anki still supports archive inspection only, not full compatibility.

## Validation

Run `python3 scripts/check_localizations.py`, `python3 scripts/check_sql_schema.py`, `python3 -m unittest discover -s tests -v`, and `python3 scripts/check_documentation_language.py`. Then run Flutter analysis, tests, and platform builds on a machine with the installed SDKs.

## Security and lifecycle notes

The storage API uses parameterized queries and SQL transactions. Repeated `operation_id` values are ignored to prevent duplicate feedback. A production review API must use a cryptographically strong unique identifier, explicit operation replay semantics, and the same atomic state transition as the review event.
