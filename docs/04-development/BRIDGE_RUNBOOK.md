# Rust / Flutter bridge integration runbook

Status: a transport-neutral Rust facade exists; Flutter FFI glue and WASM integration are **not yet connected**.

## Contract

`crates/srs_bridge/src/lib.rs` exposes `preview_review()` and `inspect_package()` with simple DTOs. `inspect_package()` is metadata-only and must never be described as an importer. No database writes are performed by either entry point.

## Steps on a machine with Flutter and Rust installed

1. Run `cargo test --manifest-path crates/Cargo.toml`.
2. Bootstrap Flutter platform folders with `bash scripts/bootstrap_flutter.sh` (inspect any generated changes first).
3. Select and pin a compatible `flutter_rust_bridge` tool and runtime version; record exact versions in the dependency register.
4. Generate Dart/native bindings against a public facade, not the internals of Anki. Wire the resulting bindings into repository abstractions.
5. Build Android arm64 and emulator targets, then iOS arm64/simulator on macOS.
6. Compile the WASM target and verify package inspection / FSRS parity in Chromium, Firefox and Safari. Keep memory and worker restrictions under test.
7. Make `StudyService` persist state changes and review events in a single SQLite transaction; test undo and repeat-submission behavior.

## Acceptance

The bridge is only considered complete after Android/iOS/Web build and device/browser smoke tests, numerical FSRS parity tests, error propagation tests, and a security review of file buffers.
