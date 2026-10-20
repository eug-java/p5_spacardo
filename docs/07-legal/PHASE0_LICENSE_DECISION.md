# Phase 0 legal/licensing gate

This is an engineering checklist, not attorney advice. The working public project name is P5 Spacardo and project-owned code is licensed under Apache-2.0. Trademark, namespace, dependency notice and distribution checks are still pending; do not publish to stores yet.

| Dependency | Direct purpose | License preliminary | Next task |
|---|---|---|---|
| fsrs 6.6.2 | FSRS scheduler | BSD-3-Clause per upstream | Pin/check every transitive dep |
| zip 9.0.2 | Archive inspection | MIT per upstream, verify | Scan transitive feature tree and security advisories |
| Flutter SDK | UI engine | BSD-3-Clause | Build full LICENSE/NOTICE |
| drift, drift_flutter | SQLite cross-platform | MIT | Audit all native/WASM assets |

**Original Anki project:** AGPL-3.0-or-later source code is not intentionally imported, copied, or linked. Reading/writing compatible file formats independently is a separate design activity; nonetheless trademark, sample-deck copyright, patent and unfair competition issues still require review.

**No trademark assertions:** `P5 Spacardo` is a selected working product name pending trademark clearance. Do not use Anki branding or implied endorsement.

References:
- https://github.com/ankitects/anki/blob/main/LICENSE
- https://github.com/open-spaced-repetition/fsrs-rs/blob/main/LICENSE
- https://github.com/dart-lang/sdk/blob/main/LICENSE
- https://cjycode.com/flutter_rust_bridge/quickstart

Pinned to zip 9.0.2 because earlier release series were reported yanked in October 2026; verify availability and API compatibility using Cargo. https://crates.io/crates/zip
