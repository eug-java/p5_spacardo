# Phase 0.2 Implementation Status

## Implemented in source

- Persisted locale preference using `SharedPreferencesAsync` (when platform storage is available).
- SQLite-backed deck listing and creation with parameterized inserts and explicit validation.
- Adapted the starter bootstrap identity to `p5_spacardo` and `org.pilot5`.
- Retained the transport-neutral Rust FSRS / ZIP inspection contract.
- Introduced 8 new localization message identifiers across all 18 ARB catalogs. Translation values are English placeholders requiring professional review.

## Not yet implemented

- Generated flutter_rust_bridge bindings (native or web) or verified WASM builds.
- Full APKG/COLPKG importer and exporter.
- Persisted note/card editing, real review sessions, and FSRS persistence.
- Comprehensive localization QA and backups.

## How to verify on a developer machine

1. Install Flutter SDK and Rust toolchain; follow `docs/04-development/SETUP_LINUX.md` or `SETUP_MACOS.md`.
2. Run `bash scripts/bootstrap_flutter.sh` from the repo root.
3. Run `flutter run -d chrome` in `apps/mobile` (web persistence requires wasm resources provisioned per Drift docs).
4. Create a deck and restart the application. Confirm the deck survives. Change language and restart. Confirm the preference survives.
5. On Android and iOS, repeat the persistence tests using actual devices.
6. Run `python3 -m unittest discover -s tests -v` and other validation scripts.

No Flutter, Dart or Rust compiler is available in the delivery environment. This is source-level progress, not a confirmed build.

## Release blockers

The SQLite web worker assets, generated native platform projects, Rust bridge, translation verification and actual cross-platform builds all remain blockers. Do not publish this scaffold as a finished app.
