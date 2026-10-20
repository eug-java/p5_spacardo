# Linux Setup - Android and Web

Status: DRAFT until toolchain versions and commands are validated on a reproducible host. iOS cannot be built locally with Xcode on Linux.

## Prerequisites
Linux x86_64, Git, Flutter stable, Android Studio with matching SDK/Build Tools, JDK compatible with pinned Android Gradle Plugin, Chrome for Flutter Web, Android device or emulator, Rust stable through rustup. Pin versions before the first public build.

## Installation and checks
1. Install Flutter following https://docs.flutter.dev/get-started/install . Add `flutter/bin` to PATH.
2. Install Android Studio, Android SDK, command-line tools, emulator/platform tools.
3. Install Rust from https://rustup.rs/ .
4. Check:
```bash
flutter --version
flutter doctor -v
flutter devices
rustc --version
cargo --version
adb devices
```
5. Review and accept Android SDK licenses when appropriate:
```bash
flutter doctor --android-licenses
```
6. For Web WASM development when enabled:
```bash
rustup target add wasm32-unknown-unknown
```

## Project checks
```bash
# From repository root
python3 -m unittest discover -s tests -v
python3 scripts/check_sql_schema.py
python3 scripts/check_documentation_language.py
bash scripts/bootstrap_flutter.sh
cargo test --manifest-path crates/Cargo.toml
```
After generation and package resolution:
```bash
cd apps/mobile
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
# Replace DEVICE_ID using `flutter devices` output.
flutter run -d DEVICE_ID
```

## Troubleshooting
`flutter doctor` missing SDK: check `ANDROID_SDK_ROOT` and installed components. Device missing: check `adb devices` and USB debugging. WASM failing: verify generated bindings, supported browser environment, workers, and response headers. Rust FFI failing: check correct target triples and bindings. The starter has not completed native builds; report findings in `PHASE0_STATUS.md`.
