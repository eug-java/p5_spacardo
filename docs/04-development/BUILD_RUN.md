# Build, Run, and Test

Status: DRAFT. The current project is an uncompiled Phase 0 starter, not a publishable build.

## Repository root checks
```bash
python3 -m unittest discover -s tests -v
python3 scripts/check_sql_schema.py
python3 scripts/check_documentation_language.py
cargo fmt --manifest-path crates/Cargo.toml --all -- --check
cargo test --manifest-path crates/Cargo.toml
```

## Bootstrap and Flutter
```bash
bash scripts/bootstrap_flutter.sh
cd apps/mobile
flutter pub get
flutter analyze
flutter test
flutter devices
flutter run -d chrome
```
For Android, replace the device ID with one returned by `flutter devices`.

## Release build commands (not yet verified)
```bash
flutter build apk --release
flutter build appbundle --release
flutter build web --release
# Run on macOS with installed Xcode and valid signing:
flutter build ios --release
```
These commands do not prove Rust linkage, WebAssembly integration, or working Anki interoperability. Record exact environment, failures, expected outputs, and fixes in `PHASE0_STATUS.md` before treating a workflow as verified.

## Final checks
No real user collection, keys, account credentials, or copyrighted test decks in git or artifacts. Dependency licenses audited, English docs pass review, platform permissions minimized, privacy policy finalized and publicly accessible.
