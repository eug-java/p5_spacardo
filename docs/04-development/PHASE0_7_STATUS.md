# Phase 0.7 - Native FSRS ABI spike

## Scope

This changeset adds a versioned C ABI around the Rust `fsrs` preview, a Dart
FFI wrapper with explicit C struct layout, and a platform-conditional factory.
The native entry point is `spacardo_fsrs_preview_v1`.

The Dart UI still deliberately blocks ratings. The native library is not yet
packaged, and calling it has not been verified with a real Flutter build.
There is no WebAssembly scheduler yet. The Web factory explicitly returns null.
The application does **not** claim an end-to-end working FSRS loop.

## Memory and ABI contract

- `has_previous=0` ignores previous state; `1` requires both positive finite
  stability and difficulty in `(0, 10]`.
- `elapsed_days` uses whole days and excludes sub-day learning/relearning.
- `retention` must be finite in `[0.70, 0.99]`.
- Result is four `#[repr(C)]` records of three `f32` fields.
- Return codes: `0` success, `1` null out pointer, `2` invalid input or
  scheduler error, `3` panic; no exception may cross the C ABI.
- Native libraries must be built for each mobile architecture and pinned to
  the same git revision as Dart code.
- The Rust library is not yet a replacement for the application scheduling
  service: learning steps, timezone rollover, stale-state checks and history
  migration still need completion.

## Developer checks

```bash
python3 -m unittest discover -s tests -v
python3 scripts/check_sql_schema.py
python3 scripts/check_localizations.py
python3 scripts/check_documentation_language.py
cargo test --manifest-path crates/Cargo.toml
cd apps/mobile && flutter pub get && flutter analyze && flutter test
```

Rust/Flutter toolchains are required for the final two commands.

## Release blockers

1. Verify `cargo test` and native ABI layout on a supported toolchain.
2. Compile and link Android ARM64/x86_64 and iOS device/simulator libraries.
3. Verify the native symbol can be loaded and survives missing-library errors.
4. Build and test WebAssembly using a browser-safe bridge implementation.
5. Add an application service that reads the latest card state, invokes
   verified FSRS, commits atomically and supports undo, learning steps and
   a persisted session across process restarts.
6. Run parity fixtures on all three platforms.

No part of this document constitutes evidence of a successful mobile or Web
build. All public documentation remains in English.
