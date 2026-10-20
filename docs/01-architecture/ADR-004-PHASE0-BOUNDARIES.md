# ADR-004: Phase 0 implementation boundaries

Status: PROPOSED | Date: 2026-10-19

- **One frontend:** Flutter UI all platforms. No React duplicate.
- **Core:** `fsrs-rs` behind a Rust adapter; optional native/WASM bridge generated after build tools exist.
- **Anki compatibility:** independent codec; release is blocked until real imported data round-trips in Anki Desktop. A ZIP is not enough to claim compatibility.
- **Storage:** Drift/SQLite on Android/iOS/Web. The packaged Flutter shell does not yet open SQLite.
- **No server:** no user collection uploads or AnkiWeb calls. Web static assets may be served over HTTPS.
- **Licenses:** no copied Anki Rust/backend code; track transitive notices and run license audit.
- **User safety:** no study ratings are saved or advertised until DB transactions + FSRS are integrated.

## Rationale

The fastest safe path is to validate the high-risk components in isolation and not pretend a partially connected mock UI is a usable spaced repetition app.

## Exit criteria

Builds for Android/iOS/Web, stable bridge, DB persistence tests, real fixture import and export accepted by Anki Desktop.
