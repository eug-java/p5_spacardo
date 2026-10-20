# Phase 0.1 implementation status

Date: 2026-10-19. Product: P5 Spacardo. Public repository planned; not automatically published.

## Implemented

- Eighteen preliminary ARB translations (28 user-facing strings each) using Flutter's localization generation configuration.
- All visible text in the Phase 0 Flutter shell is accessed through typed localization keys except the product name, sample vocabulary and proper nouns.
- System-language selection and in-app language dropdown (state survives navigation but **not application restart**).
- Standalone Rust bridge facade with structured FSRS-preview and archive-metadata inspection contracts.
- Localization-schema validation in GitHub Actions.
- English-only developer runbooks and instructions for adding strings and integrating Rust bindings.

## Not implemented

- Full `.apkg` or `.colpkg` parser and exporter; ZIP audit is metadata-only.
- Generated Dart-to-Rust FFI bindings and compiled WebAssembly.
- Persistent deck database, review history or language preference.
- Production translation QA, RTL device tests, real-device iOS/Android builds, Web smoke tests.

## Verified in current environment

- `python3 scripts/check_localizations.py`: 18 locale sets, all 28 keys present.
- `python3 scripts/check_documentation_language.py`: 38 Markdown files scanned.
- `python3 -m unittest discover -s tests -v`: 10 tests passed.
- `python3 scripts/check_sql_schema.py`: schema smoke test passed.

Flutter/Dart and Rust toolchains are unavailable in the execution environment, so compilation and corresponding automated tests remain unverified.
