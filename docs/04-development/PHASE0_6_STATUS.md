# Phase 0.6 - FSRS integration safety milestone

## Scope and result

This iteration removes the **temporary scheduling algorithm** from the user-facing review submission path. All review buttons now refuse to persist an answer until a real Rust FSRS adapter is connected and verified. Existing reviewed data and `commitFsrsReview()` remain in the database layer for forward compatibility. The Rust scheduling facade includes deterministic and invalid-input tests; the test source is present but Rust tests could not be executed in the artifact-building environment.

**This is not a completed flutter_rust_bridge integration.** The runtime generator, Rust compiler, Dart SDK, iOS SDK, and Flutter SDK were not installed in the creation environment. Therefore no compiled bridge, WASM bundle, Android APK, or iOS IPA is claimed. The app's review buttons are intentionally disabled at the persistence layer (and show an FSRS notice) to prevent incorrect learning progress.

## Reproduction

```bash
python3 scripts/verify_phase0_6.py
python3 -m unittest discover -s tests -v
python3 scripts/check_sql_schema.py
python3 scripts/check_localizations.py
python3 scripts/check_documentation_language.py
cargo test --manifest-path crates/Cargo.toml
```

The first five commands are Python/static checks. The `cargo test` command requires a local Rust toolchain and dependency download. Flutter bootstrap: `bash scripts/bootstrap_flutter.sh` (requires Flutter SDK). Follow `BRIDGE_RUNBOOK.md` for bridge generation.

## Must complete before review buttons can be enabled

1. Pin compatible `flutter_rust_bridge` runtime, codegen, and Rust dependency versions in the lock files; generate real bindings with supported templates.
2. Implement `SchedulerRepository.preview` with Rust FSRS on native and WASM, not a Dart reimplementation or hard-coded durations.
3. After fetching the current `card_states` snapshot, calculate `elapsed_days` from the last *non-undone* review and select the rating outcome; use calendar-day conventions and learning steps compatible with the selected FSRS release.
4. Call `commitFsrsReview` with the resulting stability, difficulty, interval, phase and expected review count. Handle stale-state exceptions with a recomputation, not an automatic retry with the same outcome.
5. Test atomicity, Undo, duplicate operation IDs, offline persistence and 18-locale UI on physical Android/iOS and all supported browsers.
6. Collect fixed golden vectors from the Rust implementation and verify cross-platform parity within a documented floating-point tolerance.
7. Enable the submission UI only after the bridge reports ready; if unavailable, show a localized error, without using the former provisional scheduler.

## Explicit constraints

- The old `recordPractice` API now fails closed with `UnsupportedError`. No temporary spacing intervals remain in that method.
- The Rust preview code is NOT the whole FSRS scheduling workflow: learning/relearning steps, review history imports, parameter optimization and the Anki scheduling compatibility rules are still outstanding.
- Static source checks do not prove Flutter compiles or that persistence and FFI run correctly.
