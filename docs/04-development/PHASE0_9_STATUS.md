# Phase 0.9 - Integration hardening

## Scope

This phase fixes a Rust ABI import error, validates the native FSRS return values, rejects reuse of undone operation identifiers, and adds a reproducible CI verification script. No platform release is claimed.

## What is implemented

- The C ABI module imports its required parent-module symbols explicitly.
- The Dart FFI decoder rejects non-finite and invalid output.
- Native engine discovery is limited to Android and iOS.
- Database persistence rejects replay of undone operations and non-monotonic review timestamps.
- A host Rust smoke test is provided for environments with the Rust toolchain.

## Not implemented or not verified

- No generated Android or iOS native artifacts are bundled.
- No compilation of Rust or Flutter has been run in the authoring environment.
- Web FSRS is unavailable until a dedicated WASM adapter is implemented and tested.
- FSRS Learning/Relearning steps and Anki scheduler equivalence are NOT complete.
- Full APK, IPA, PWA and restart/end-to-end tests are pending.

## Local validation

From repository root:

```bash
python3 scripts/verify_phase0_9.py
python3 -m unittest discover -s tests -v
python3 scripts/check_sql_schema.py
python3 scripts/check_localizations.py
python3 scripts/check_documentation_language.py
cargo test --manifest-path crates/Cargo.toml
cd apps/mobile && flutter pub get && flutter analyze && flutter test
```

Do not enable study ratings in release builds without testing the actual platform library and end-to-end persistence.
