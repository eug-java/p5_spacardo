## Phase 0.10.2 - Rust FFI safety and formatting

- Marked `spacardo_fsrs_preview_v1` unsafe and documented the pointer preconditions.
- Updated Rust FFI tests to use explicit unsafe call sites.
- Applied rustfmt formatting where the tool was available.
- Verification still requires cargo fmt, clippy, tests, and release build on an installed Rust toolchain.

## Phase 0.9 - Native FFI and review-persistence hardening

- Fix missing Rust ABI module imports.
- Validate returned FSRS values at the Dart boundary.
- Reject reused undone operation identifiers and backward review timestamps.
- Add source guards and English verification instructions.
- Platform compilation and Web FSRS remain pending.

## Phase 0.8 - Native FSRS study integration (uncompiled)

- Wire native FSRS preview to the study action via `StudyReviewService`.
- Load persisted FSRS memory and last review time before scheduling.
- Persist chosen FSRS result atomically with its review event.
- Block ratings if the Rust shared library is unavailable.
- Add static integration verification and document unsupported Web and intraday scheduling.

# Changelog

## Phase 0.6 (unreleased)

- Removed provisional fixed-interval scheduling from user-facing rating flow (fail closed until actual Rust bindings are integrated).
- Added Rust deterministic scheduling tests and source regression checks.
- Documented truthful bridge and mobile/web validation blockers.


## 0.0.5 - Phase 0.5

- Added validated FSRS scheduling output persistence and optimistic write checks.
- Preserved SQLite atomic write and Undo semantics.
- Added explicit documentation of the unconnected Dart/Rust boundary.

## Phase 0.4

- Added provisional due queue and transactional review state updates.
- Added last-review undo and idempotency collision checks.
- Added explicit provisional-scheduling UI warning.
- Rust FSRS binding remains pending.

# Changelog

## Phase 0.6 (unreleased)

- Removed provisional fixed-interval scheduling from user-facing rating flow (fail closed until actual Rust bindings are integrated).
- Added Rust deterministic scheduling tests and source regression checks.
- Documented truthful bridge and mobile/web validation blockers.


All notable changes should be summarized here in English. This project uses a phase-based development status before its first semantic release.

## [Unreleased] - 2026-10-19
### Documentation and repository policy
- Translated and rewritten the public project documentation in English.
- Established the public repository documentation language standard.
- Added English contributor, security, legal and project status guidance.
- Recorded preliminary brand research while leaving the final product name unapproved.

### Prototype limitation
- No claim is made of completed Anki import/export, synchronized study history, native iOS/Android builds or WebAssembly integration.

## 0.0.2 - Phase 0.2

- Add persisted language selection and SQLite-backed deck list/create.
- Correct Flutter bootstrap project identity.
- Extend English localization keys to all 18 ARB catalogs.
- Document remaining bridge and browser storage blockers.

## 0.0.3 - Phase 0.3
- Added persisted Basic cards and practice feedback ledger.
- Added deck selection and card creation UI.
- Added nine localization keys (English provisional strings in other locales).
- No FSRS or production Anki import implementation yet.

## Phase 0.7 - native ABI groundwork (unreleased)

- Added a panic-contained, versioned C ABI for the Rust FSRS preview.
- Added Dart FFI structs, error checking and a conditional scheduler factory.
- Kept review UI disabled until native and Web parity is demonstrated.
- Documented explicit build, packaging, and parity release blockers.
