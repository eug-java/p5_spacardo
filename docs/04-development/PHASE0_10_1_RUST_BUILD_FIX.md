# Phase 0.10.1 - Rust ZIP entry name API fix

The `zip = 9.0.2` crate returns `Result<Cow<str>, ZipError>` from `ZipFile::name()`.
The Anki archive metadata inspector previously passed that result directly to string APIs.

## Fix

Unwrap the `Result` with explicit mapping to `AuditError::InvalidZip`, then use the borrowed `&str` across all preflight checks. The rest of the archive validation is unchanged.

## Verify locally

```sh
cargo test --manifest-path crates/Cargo.toml
cargo fmt --manifest-path crates/Cargo.toml --all -- --check
cargo clippy --manifest-path crates/Cargo.toml --all-targets -- -D warnings
```

The patch was inspected and Python tests were executed; Rust compilation was not available in the packaging environment.
