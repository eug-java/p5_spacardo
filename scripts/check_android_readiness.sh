#!/usr/bin/env bash
# Non-destructive Android build readiness audit. Does not build APKs.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOBILE="$ROOT/apps/mobile"
printf 'Project: %s\n' "$ROOT"
if ! command -v flutter >/dev/null; then echo 'ERROR: flutter missing'; exit 1; fi
if ! command -v cargo >/dev/null; then echo 'ERROR: cargo missing'; exit 1; fi
flutter --version
flutter doctor -v
if [[ -d "$MOBILE/android" ]]; then
  echo 'Android runner: present'
else
  echo 'Android runner: NOT PRESENT'
  echo 'Generate when ready: (cd apps/mobile && flutter create --platforms=android --project-name p5_spacardo .)'
fi
if [[ -f "$MOBILE/android/app/build.gradle.kts" || -f "$MOBILE/android/app/build.gradle" ]]; then
  echo 'Gradle app configuration: present'
else
  echo 'Gradle app configuration: NOT PRESENT'
fi
if command -v rustup >/dev/null; then
  rustup target list --installed | grep -E 'aarch64-linux-android|armv7-linux-androideabi|x86_64-linux-android' || echo 'Rust Android targets: none installed'
fi
for abi in arm64-v8a armeabi-v7a x86_64; do
  file="$MOBILE/android/app/src/main/jniLibs/$abi/libsrs_bridge.so"
  if [[ -f "$file" ]]; then echo "Native library ($abi): present"; else echo "Native library ($abi): MISSING"; fi
done
cat <<'NOTE'
NOTE: a successful flutter build apk does not guarantee the FSRS native
library is packaged. Do not publish until relevant ABI .so files are built,
packaged, verified in APK, and tested on an Android device/emulator.
NOTE
