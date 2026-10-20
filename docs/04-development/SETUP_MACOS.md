# macOS Setup - iOS, Android, and Web

Status: DRAFT pending a validated development host.

## Prerequisites
Supported macOS and Xcode versions per selected Flutter release, Apple command-line tools, CocoaPods if required, Flutter SDK, Android SDK, Rust stable, browser, and an Apple Developer account for distribution/signing as appropriate.

## Install and verify
1. Install Xcode from the official Apple distribution and run `xcode-select --install` if needed.
2. Open Xcode once to review required components/licenses, configure simulators, and check signing identities.
3. Install Flutter: https://docs.flutter.dev/get-started/install/macos .
4. Install Rust: https://rustup.rs/ .
5. Run:
```bash
xcodebuild -version
flutter doctor -v
flutter devices
rustc --version
cargo --version
```
6. From repository root run `bash scripts/bootstrap_flutter.sh`, the Python tests, and `cargo test --manifest-path crates/Cargo.toml`.
7. From `apps/mobile`, run `flutter pub get`, `flutter analyze`, and `flutter test`.
8. Test simulator `flutter run -d <SIMULATOR_ID>` and physical device after development signing configuration.

## Release considerations
Use Xcode/macOS for iOS build signing, TestFlight and App Store submission. Verify iOS Rust device/simulator target architectures and package compatibility. Never commit Apple certificates, private keys, provisioning profiles, or secrets. Exact minimum OS/Xcode requirements must be pinned after Phase 0 validation.
