# Phase 0 - developer runbook (Android + iOS + Web)

## Prerequisites

- Linux/macOS: Flutter stable, Dart bundled with Flutter, Git, Android Studio/SDK, Java 17+, Rust stable, Cargo, Python 3.10+.
- iOS builds require macOS, Xcode and CocoaPods configured per current Flutter requirements.
- Web: recent Chrome/Firefox/Safari; a proper HTTPS host with WASM assets for production.
- Command versions MUST be pinned in lockfiles before release; this archive intentionally contains no fake lockfiles.

## 1. Generate Flutter platform projects

From root:

```bash
bash scripts/bootstrap_flutter.sh
```

This invokes `flutter create . --platforms=android,ios,web` and preserves `lib/main.dart` and `pubspec.yaml`. It has not been run by the archive author because Flutter is unavailable in the preparation environment. Review any modifications reported by Flutter before committing.

## 2. Test Rust crates

```bash
cargo test --manifest-path crates/Cargo.toml
cargo fmt --manifest-path crates/Cargo.toml --all -- --check
cargo clippy --manifest-path crates/Cargo.toml --workspace --all-targets -- -D warnings
```

The ZIP preflight crate targets zip 9.0.2; validate compatibility with installed Rust MSRV. Both Rust crates are previews only. The codec only inspects ZIP metadata, does not decode Anki SQLite/Zstd and cannot export packages. `fsrs-rs` API source: https://docs.rs/fsrs/latest/fsrs/ .

## 3. Run Flutter app shell

```bash
cd apps/mobile
flutter pub get
flutter run -d chrome
# or choose a connected Android device:
flutter devices
flutter run -d <device-id>
```

To enable Drift persistence in Web, fetch or generate matching `sqlite3.wasm` and `drift_worker.js` per https://drift.simonbinder.eu/platforms/web/ ; add the two files to `apps/mobile/web/` and validate persistence. The current UI does not open the database, so the demonstration does NOT prove persistent storage.

## 4. Integrate Rust into Flutter (blocked pending toolchains)

Use official `flutter_rust_bridge_codegen integrate` inside Flutter app, carefully reviewing any generated or overwritten files. Configure it to point to the intended Rust integration crate. Do **not** run integrate over uncommitted changes. The current two crates have no FFI glue. See https://cjycode.com/flutter_rust_bridge/quickstart and https://cjycode.com/flutter_rust_bridge/manual/integrate/builtin . After each change run `flutter_rust_bridge_codegen generate`; web needs a separate `flutter_rust_bridge_codegen build-web` step. Integrating the bridge must include a native + WASM parity golden test before enabling study ratings.

## 5. Independent Python audits (available immediately)

```bash
python3 -m unittest discover -s tests -v
python3 scripts/check_sql_schema.py
python3 tools/anki_archive_audit.py path/to/deck.apkg
```

These tests do NOT prove Anki import/export compatibility.

## 6. Acceptance gates

- [ ] `cargo test` clean on supported targets
- [ ] Flutter analyze, widget tests and builds pass
- [ ] Rust bridge returns FSRS identical results on Android/iOS/Web
- [ ] Real Anki fixture decoded in all platforms, media and progress verified
- [ ] Export imported in Anki Desktop round-trip
- [ ] Browser persists database across reload and app update
- [ ] Imported decks are backed up before any destructive operation
- [ ] License scans, NOTICE and privacy policy approved before public release

## 7. Known blockers

No local Flutter/Rust toolchains in initial preparation; npm/pip package availability does not substitute for them. Exact dependency compatibility must be checked on a connected development machine. Android/iOS signing and branding are deliberately not configured.
