# Phase 0.10.2 verification

The Linux release build and 11 Rust unit tests passed in the user environment before this patch. Clippy reported `not_unsafe_ptr_arg_deref`; `cargo fmt --check` reported formatting differences. This patch addresses the FFI signature and tests.

Run:

```sh
cargo fmt --manifest-path crates/Cargo.toml --all
cargo fmt --manifest-path crates/Cargo.toml --all -- --check
cargo clippy --manifest-path crates/Cargo.toml --all-targets -- -D warnings
cargo test --manifest-path crates/Cargo.toml
cargo build --manifest-path crates/Cargo.toml --release
```

The shared library has not yet been validated from Flutter or on devices.
