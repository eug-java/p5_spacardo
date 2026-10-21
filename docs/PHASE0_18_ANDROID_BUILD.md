# Phase 0.18 — Reproducible Android ARM64 build

This update adds a **separate** GitHub Actions workflow and one local script. It does not replace existing workflows or alter application, database, or scheduler code.

## Prerequisites

- Flutter 3.47.7 and Rust 1.99.1 (the versions used in the verified development environment)
- Android SDK, Android NDK and accepted SDK licenses
- A Linux x86_64 build host
- Rust target `aarch64-linux-android` (the script installs it when missing)
- The existing Flutter Android runner in `apps/mobile/android`

## Local usage

From the repository root:

```bash
bash scripts/build_android_arm64.sh debug
```

To build a release-mode APK for internal testing (not signed for store distribution):

```bash
bash scripts/build_android_arm64.sh release
```

By default, the script selects the highest installed side-by-side NDK. To pin one explicitly:

```bash
SPACARDO_ANDROID_NDK_VERSION=28.2.13676358 bash scripts/build_android_arm64.sh debug
```

The script compiles the Rust `srs_bridge` crate for Android ARM64, copies the resulting `libsrs_bridge.so` into Flutter's `jniLibs/arm64-v8a`, builds an APK, checks archive integrity, verifies `libflutter.so` and the embedded FSRS library, and compares the embedded FSRS library byte-for-byte against the compiled output.

## CI behavior

`.github/workflows/android-arm64.yml` runs on pull requests, pushes to `main`, and manual dispatch. It builds a debug APK and retains it as a workflow artifact for seven days. The existing Linux E2E workflow remains unchanged.

## Scope and limitations

- The output targets **only Android ARM64** (`arm64-v8a`). It does not support 32-bit ARM or x86_64 emulators.
- APK packaging checks do **not** substitute for runtime testing on a device.
- A release-mode APK is not automatically Play Store-ready: application ID, signing, icon, versioning, release testing, and store distribution must be configured separately.
- Generated `.so` and `.apk` files should remain excluded from Git. CI creates them from source.
- The script is deliberately explicit rather than a hidden Gradle integration. Android builds performed directly with `flutter build apk` will not regenerate Rust libraries unless this script ran first.
- The next phase should add Flutter widget regression tests for dialog ownership and eventually formal Gradle native build integration.
