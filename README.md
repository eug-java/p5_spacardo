> Phase 0.9: native ABI and persistence hardening only. Real Rust/Flutter device builds are still unverified. See [Phase 0.9 status](docs/04-development/PHASE0_9_STATUS.md).

> Project name: P5 Spacardo. Public repository planned; the actual GitHub URL is not yet verified. Trademark clearance is pending.
> Documentation language: English only. Localization scope: 18 complete ARB resource sets with preliminary, unreviewed translations.
> License: Apache-2.0 for project-owned source; third-party licenses remain applicable.

# Cross-platform Spaced Repetition - Phase 0.2 Development Scaffold

**Project status:** Technical spike / incomplete scaffold. **Public product name:** P5 Spacardo (trademark clearance pending). **Date:** 2026-10-19.

An independent, free-to-use, ad-free, local-first spaced repetition learning application targeting Android, iOS and Web/PWA. Planned support includes FSRS scheduling and import/export of selected Anki `.apkg`/`.colpkg` formats. The Anki compatibility claim is a goal, not an implemented capability.

## Status - do not confuse plan with implementation

**Implemented in scaffold:** localized Flutter demo shell with transient language selection; Rust facade contract without generated bindings; SQLite schema scaffolding; Rust FSRS adapter experiments; a *metadata-only* Python ZIP inspector with synthetic regression tests; English product, platform and legal documentation.

**Not implemented or verified:** full Anki import/export; review persistence end-to-end; wired native Rust bridge and WebAssembly parity; reproducible Android/iOS/Web builds; automatic device sync; shipped stable app.

**Environment verification from the prior archive:** Python ZIP-inspector regression tests and SQL schema checks ran during initial preparation. Flutter and Rust SDKs were unavailable, so native builds and Rust compilation were not verified. Tests should be rerun for this revision.

## Repository structure
```text
apps/mobile/       Flutter frontend and platform scaffolding
crates/            Rust experiments for FSRS and Anki format parsing
docs/              English-only requirements, architecture, setup, security, legal guidance
scripts/           Bootstrap, schema and documentation checks
tests/             Python archive inspector regression tests
tools/             Metadata-only archive audit CLI
.github/           Public repository CI and templates
```

## Getting started (Linux / macOS)
```bash
python3 scripts/check_documentation_language.py
python3 scripts/check_localizations.py
python3 -m unittest discover -s tests -v
python3 scripts/check_sql_schema.py
bash scripts/bootstrap_flutter.sh  # Requires Flutter SDK and local platform tools
cargo test --manifest-path crates/Cargo.toml  # Requires Rust toolchain
```
Read `docs/04-development/PHASE0_RUNBOOK.md` for limitations and full setup. `docs/04-development/SETUP_LINUX.md` and `SETUP_MACOS.md` cover platform prerequisites.

## Documentation language
All repository documentation, issue/PR templates and public API commentary must be written in English. UI translations are allowed only in localization resources, following `docs/00-product/DOCUMENTATION_POLICY.md`.

## Free to use vs. source license
The planned apps are completely free to end users, with no ads or subscriptions. **Publishing source on GitHub is not itself an open-source license.** The project-owned original source code is licensed under Apache-2.0 (see root `LICENSE`). Third-party components retain their own licenses. See `docs/07-legal/LICENSE_COMPLIANCE.md`.

## Independence
This is not an official Anki app and is not affiliated with or endorsed by Ankitects. Anki is mentioned only for accurate description of planned file-format interoperability. Do not import or include Anki's AGPL-covered source code or proprietary media without license review.

## Contributing / security
See `CONTRIBUTING.md`, `SECURITY.md`, the documentation policy, and `docs/08-release/RELEASE_CHECKLIST.md`. Do not add private user data, copyrighted deck fixtures or credentials to a public repository.

## Phase 0.1 notes

See `docs/00-product/LOCALIZATION_IMPLEMENTATION.md` and `docs/04-development/BRIDGE_RUNBOOK.md`. The UI is still a demonstration. Translation review, persisted settings, Rust FFI/WASM wiring and full Anki import/export are not yet complete.

## Phase 0.2

Persisted locale preferences and basic SQLite deck creation/listing are now included as source code. See `docs/04-development/PHASE0_2_STATUS.md`. Runtime builds have not been verified.

## Phase 0.3 status

The Basic-card practice UI and persistence implementation are available for SDK-level validation, but the app is **not yet a production-ready spaced-repetition application**. Practice ratings are recorded without scheduling intervals. See [Phase 0.3 status](docs/04-development/PHASE0_3_STATUS.md) before running or contributing.


### Phase 0.6 status

The provisional rating scheduler was removed from the application path. Rating is intentionally blocked until a verified Rust FSRS integration is available. See `docs/04-development/PHASE0_6_STATUS.md`.


Phase 0.7 native FSRS ABI experiment: see `docs/04-development/PHASE0_7_STATUS.md`. Native and Web builds remain unverified; review submission remains disabled.
