#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT"
cargo build --manifest-path crates/Cargo.toml --release
export SPACARDO_FSRS_LIBRARY="$ROOT/crates/target/release/libsrs_bridge.so"
if [[ ! -f "$SPACARDO_FSRS_LIBRARY" ]]; then
  echo "Rust library is missing: $SPACARDO_FSRS_LIBRARY" >&2
  exit 1
fi
cd apps/mobile
flutter analyze
flutter test test/fsrs_native_persistent_e2e_test.dart --reporter expanded
