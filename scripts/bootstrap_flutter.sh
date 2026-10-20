#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if ! command -v flutter >/dev/null 2>&1; then
  echo 'ERROR: Flutter SDK not in PATH; see docs/04-development/PHASE0_RUNBOOK.md' >&2
  exit 2
fi
cd "$ROOT/apps/mobile"
flutter create . --project-name p5_spacardo --org org.pilot5 --platforms=android,ios,web --no-pub
flutter pub get
flutter analyze
flutter test
printf '
Flutter shell generated. Android/iOS/Web SDK builds and Rust bridge are still pending.
'
