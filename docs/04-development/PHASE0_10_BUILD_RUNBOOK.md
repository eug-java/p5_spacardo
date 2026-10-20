# Phase 0.10 - Build Verification Runbook

## Scope

This phase prioritizes executable validation. It does not claim working mobile or web builds.

## Linux prerequisites

Install Flutter SDK, Android SDK, Rust (rustup), and platform build tools. Verify with `flutter doctor -v`, `cargo --version`, and `rustc --version`.

## Local validation

```bash
python3 -m unittest discover -s tests -v
python3 scripts/check_sql_schema.py
python3 scripts/check_localizations.py
python3 scripts/check_documentation_language.py
cargo test --manifest-path crates/Cargo.toml
cd apps/mobile
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
```

## Native targets

Build the Rust `srs_bridge` library for Android targets and iOS targets separately. Package the shared library for Android and link the static library for iOS. Verify symbol export and Dart FFI struct layout before enabling grading. iOS builds require macOS and Xcode.

## Browser

The native `dart:ffi` adapter cannot execute in a browser. Implement a separate WebAssembly adapter, test it on supported browsers, and only then enable grading on Web. Drift web database assets and persistence must also be verified.

## Release blockers

- Native library packaging and ABI tests
- Full learning/relearning steps
- Browser WebAssembly bridge
- End-to-end persistence and undo tests
- Android/iOS/Web runtime smoke tests

## Verification policy

Only tests actually executed in a configured environment may be marked as passed. Static checks do not prove runtime compatibility.
