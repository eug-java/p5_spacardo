# Phase 0.16 — Linux CI and Android readiness

## Changes

This incremental patch adds a **separate** GitHub Actions workflow, leaving the existing documentation/Python checks unchanged. It builds the real Rust cdylib, runs Rust checks, executes all Flutter tests including the native SQLite reopen/Undo test, and compiles the Linux application.

The CI uses Flutter 3.47.7 and Rust 1.99.1, matching the tested developer versions. These are CI toolchain pins, not lockfile changes. The workflow runs on `ubuntu-24.04`.

## Installation

Extract from the project root, preserving paths:

```bash
unzip -o p5_spacardo_phase0_16_ci_android.zip -d /path/to/p5_spacardo
cd /path/to/p5_spacardo
git diff -- .github/workflows/flutter-rust-integration.yml scripts/check_android_readiness.sh docs/PHASE0_16_CI_ANDROID.md
git add .github/workflows/flutter-rust-integration.yml scripts/check_android_readiness.sh docs/PHASE0_16_CI_ANDROID.md
git commit -m 'ci: validate Rust FSRS and Flutter native E2E on Linux'
git push
```

## Android audit (no side effects)

```bash
bash scripts/check_android_readiness.sh
```

If the Android runner is missing, it can be generated with:

```bash
cd apps/mobile
flutter create --platforms=android --project-name p5_spacardo .
```

**Android release is not enabled by this patch.** Android needs cross-compiled `libsrs_bridge.so` in the correct `jniLibs/<ABI>` paths or an equivalent native assets pipeline. The Linux .so file cannot be copied into an Android APK. Android NDK configuration, minSdk compatibility, ABI verification, and on-device tests must be completed before a distributable APK can be claimed.

## Troubleshooting

- If native E2E fails with missing library, check that `crates/target/release/libsrs_bridge.so` exists and is readable.
- If Flutter Linux build fails, inspect the runner platform files and required apt packages. On a GitHub Actions failure, use the job log as source of truth.
- Flutter dependencies are resolved with the repository's existing constraints. Commit the tested `pubspec.lock` if this is treated as an application, and ensure the Rust `Cargo.lock` is tracked for reproducibility.
- Existing tests must be committed to the repo before the CI job can run them.
