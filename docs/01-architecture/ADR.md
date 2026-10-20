# Architecture Decision Record Index

Status: PROPOSED. ADRs are immutable after acceptance; supersede by new ADRs rather than rewriting history.

## ADR-001 - Flutter for Android, iOS, and Web
Decision: one Flutter application for all targets with responsive layouts and platform adapters. Consequence: platform integrations must be tested individually, while domain logic remains shared.

## ADR-002 - Local-first SQLite via Drift
Decision: one database schema across targets. Native SQLite on Android/iOS, SQLite WASM with OPFS/IndexedDB where supported on Web. Consequence: browser storage is not a durable backup; use explicit file backup/restore.

## ADR-003 - Independent FSRS and Anki compatibility core
Decision: Rust scheduling via fsrs-rs and a separately implemented Anki package codec, with no direct Anki backend dependency by default. Consequence: higher development/testing cost, simpler license boundaries.

## ADR-004 - Phase 0 scope limits
See `ADR-004-PHASE0-BOUNDARIES.md`. Current prototypes must not be represented as completed Anki import/export or integrated FSRS.

## ADR-005 - No sync server in MVP
Decision: local files and package transfer only. Consequence: users must manage multiple device histories and backups; no automatic merge is promised.

## ADR-006 - Public repository, English documentation
Decision: all repository documentation, contributor text, public comments and templates use English; localization is in dedicated resource files. Consequence: language validation runs in CI.

## ADR-007 - Branding pending trademark clearance
Decision: retain internal neutral technical name until a product mark is cleared. Candidate names are research leads, not authorized final brands.
