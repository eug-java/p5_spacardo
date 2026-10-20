# Phase 0.5 - FSRS Persistence Boundary

## Implemented

- Existing `srs_fsrs` provides a four-choice preview based on the `fsrs` Rust crate, using the default parameters of the pinned dependency.
- `FsrsReviewOutcome` validates finite stability, difficulty and interval values.
- `commitFsrsReview` accepts a scheduler-computed result, checks a per-card review count and atomically updates the card state and appends an immutable review event.
- The existing `undoLastReview` restores phase, due date, stability and difficulty from the preceding snapshot.
- Existing provisional `recordPractice` remains for manual prototype testing and MUST NOT be shipped as FSRS.

## Important limitations

- `flutter_rust_bridge` bindings have **not** been generated or compiled. The Flutter UI is **not yet calling Rust FSRS**. Do not label the UI as using FSRS.
- `expectedReviewCount` prevents a subset of stale writes, but this is not a full distributed synchronization protocol. Read, calculate and write require appropriate single-writer coordination.
- FSRS preview alone does not implement complete Anki-style learning steps, timezone-based study day boundaries, fuzz, presets, parameter optimization, or compatibility migrations.
- The Rust workspace has not been compiled in this environment.
- Native Android/iOS and WASM builds are not verified.
- APKG parsing remains at archive inspection stage, not real collection import.

## Next actions

1. Install Flutter SDK and Rust toolchain on the development host.
2. Validate the pinned `fsrs` API with `cargo test --workspace`.
3. Generate `flutter_rust_bridge` bindings for Android, iOS and Web.
4. Implement a scheduler adapter that atomically reads a current state, calculates in Rust and commits; refuse fallback to provisional intervals.
5. Add device and browser integration tests and independently compare FSRS outputs.
6. Stop using `recordPractice` in the study UI after scheduler integration.

## Verification

Run `python3 -m unittest discover -s tests -v` and the project-specific check scripts. These verify Python/SQLite invariants only, not Flutter or Rust compilation.
