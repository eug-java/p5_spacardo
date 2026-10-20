# Phase 0.8 - Native FSRS Study Integration

## Scope

This iteration connects the existing experimental native FSRS ABI to the Flutter study action through `StudyReviewService`, the persisted FSRS memory snapshot, and `commitFsrsReview` transaction. No heuristic fallback is used. The code is provided as an uncompiled integration candidate.

## Lifecycle

1. Load the platform-native `srs_bridge` shared library.
2. Fetch current persisted memory, last review timestamp, and count of active review events.
3. Preview four outcomes via the Rust FSRS C ABI.
4. Select the requested rating and validate the result.
5. Persist the FSRS memory, due date, and review event in one SQLite transaction.
6. Refresh the due-card queue and make the latest review eligible for Undo.

## Important limitations

- **No native or Flutter compilation has been performed in the authoring environment.** The bridge and UI must be built and tested on actual devices.
- The Web scheduler remains intentionally unavailable pending a WASM adapter.
- Native shared libraries are not bundled; ratings stay disabled until a compatible binary is loaded.
- Intraday learning/relearning steps, FSRS parameters versioning, presets and Anki parity are NOT completed. Initial implementation treats non-Again results as review and Again as relearning. This is provisional state handling, not production-level Anki scheduling compatibility.
- The existing optimistic count guard prevents common stale writes but does not protect against all cross-process or undo-version concurrency races.
- Existing SQLite drift setup is not verified on browser targets.

## Local acceptance steps

```sh
python3 scripts/verify_phase0_8.py
python3 -m unittest discover -s tests -v
python3 scripts/check_sql_schema.py
python3 scripts/check_localizations.py
python3 scripts/check_documentation_language.py
cargo test --manifest-path crates/Cargo.toml
cd apps/mobile && flutter pub get && flutter analyze && flutter test
```

Before enabling ratings in a production build, compile the native artifact for the specific ABI, link/bundle it, run a real native study cycle, restart the application, and verify the due timestamp and Undo behavior. Test Android, iOS and Web separately.
