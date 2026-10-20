# Phase 0 verification record - 2026-10-19

| Item | State | Evidence |
|---|---|---|
| Existing documentation carried over | Done | 24 pre-existing files copied |
| Rust FSRS scheduling adapter | Written, UNCOMPILED | crates/srs_fsrs/ |
| Rust package ZIP metadata preflight | Written, UNCOMPILED | crates/srs_anki_codec/ |
| Flutter adaptive app shell | Written, UNCOMPILED | apps/mobile/lib/main.dart |
| SQLite DDL schema smoke | VERIFIED (SQLite, Python) | 11 DDL statements, FK constraint passed |
| Synthetic ZIP parser regression tests | VERIFIED (Python) | 10 synthetic tests passed |
| Android build | NOT RUN | SDK unavailable |
| iOS build | NOT RUN | SDK unavailable; macOS required |
| Web build | NOT RUN | Flutter unavailable |
| FSRS Rust bridge | NOT CONNECTED | Next milestone |
| APKG/COLPKG import/export | NOT IMPLEMENTED | Only ZIP header/metadata inspection |
| Legal dependency review | PENDING | Third-party register is preliminary |

Update this status only when commands have actually completed; do not infer successful native/WASM compilation from documentation.
