#!/usr/bin/env bash
# Build and verify an Android ARM64 APK containing the Rust FSRS library.
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MOBILE="$ROOT/apps/mobile"
SDK="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}}"
NDK_VERSION="${SPACARDO_ANDROID_NDK_VERSION:-}"
MODE="${1:-debug}"

if [[ "$MODE" != "debug" && "$MODE" != "release" ]]; then
  echo "Usage: $0 [debug|release]" >&2
  exit 2
fi

command -v cargo >/dev/null || { echo 'cargo is missing' >&2; exit 1; }
command -v rustup >/dev/null || { echo 'rustup is missing' >&2; exit 1; }
command -v flutter >/dev/null || { echo 'flutter is missing' >&2; exit 1; }
command -v unzip >/dev/null || { echo 'unzip is missing' >&2; exit 1; }

if [[ -z "$NDK_VERSION" ]]; then
  if [[ ! -d "$SDK/ndk" ]]; then
    echo "Android NDK not found in $SDK/ndk" >&2
    exit 1
  fi
  NDK_VERSION="$(find "$SDK/ndk" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort -V | tail -1)"
fi

NDK_BIN="$SDK/ndk/$NDK_VERSION/toolchains/llvm/prebuilt/linux-x86_64/bin"
LINKER="$NDK_BIN/aarch64-linux-android24-clang"
if [[ ! -x "$LINKER" ]]; then
  echo "Android NDK ARM64 linker not found: $LINKER" >&2
  exit 1
fi

TARGET='aarch64-linux-android'
if ! rustup target list --installed | grep -Fxq "$TARGET"; then
  echo "Rust target $TARGET missing; installing it"
  rustup target add "$TARGET"
fi

echo "Building srs_bridge for $TARGET with NDK $NDK_VERSION"
(
  cd "$ROOT"
  CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER="$LINKER" \
    cargo build --manifest-path crates/Cargo.toml --release --target "$TARGET" -p srs_bridge
)

SOURCE="$ROOT/crates/target/$TARGET/release/libsrs_bridge.so"
DEST_DIR="$MOBILE/android/app/src/main/jniLibs/arm64-v8a"
DEST="$DEST_DIR/libsrs_bridge.so"
test -s "$SOURCE" || { echo "Missing Rust artifact: $SOURCE" >&2; exit 1; }
mkdir -p "$DEST_DIR"
cp "$SOURCE" "$DEST"
cmp -s "$SOURCE" "$DEST" || { echo 'Native library copy verification failed' >&2; exit 1; }

(
  cd "$MOBILE"
  flutter pub get
  flutter build apk --"$MODE" --target-platform android-arm64
)

APK="$MOBILE/build/app/outputs/flutter-apk/app-$MODE.apk"
test -s "$APK" || { echo "Missing APK: $APK" >&2; exit 1; }
if ! unzip -tq "$APK" >/dev/null; then
  echo 'APK ZIP integrity check failed' >&2
  exit 1
fi
for LIB in 'lib/arm64-v8a/libsrs_bridge.so' 'lib/arm64-v8a/libflutter.so'; do
  if ! unzip -Z -1 "$APK" | grep -Fx "$LIB" >/dev/null; then
    echo "Missing native library in APK: $LIB" >&2
    exit 1
  fi
done

# Verify the embedded ARM64 ELF and its executable/read-only sections.
EXTRACTED="$(mktemp)"
CHECK_DIR="$(mktemp -d)"
trap 'rm -f "$EXTRACTED"; rm -rf "$CHECK_DIR"' EXIT

unzip -p "$APK" 'lib/arm64-v8a/libsrs_bridge.so' > "$EXTRACTED"
test -s "$EXTRACTED" || { echo 'Embedded FSRS library is empty' >&2; exit 1; }

for FILE in "$SOURCE" "$EXTRACTED"; do
  readelf -h "$FILE" | grep -Eq 'Machine:.*AArch64' || {
    echo "Not an AArch64 ELF: $FILE" >&2
    exit 1
  }
done

OBJCOPY="$NDK_BIN/llvm-objcopy"
test -x "$OBJCOPY" || { echo "Missing llvm-objcopy: $OBJCOPY" >&2; exit 1; }

for SECTION in .text .rodata; do
  "$OBJCOPY" --dump-section "$SECTION=$CHECK_DIR/source" "$SOURCE"
  "$OBJCOPY" --dump-section "$SECTION=$CHECK_DIR/apk" "$EXTRACTED"

  cmp -s "$CHECK_DIR/source" "$CHECK_DIR/apk" || {
    echo "APK FSRS section mismatch: $SECTION" >&2
    exit 1
  }
  echo "PASS: $SECTION matches"
done

echo "PASS: Android $MODE APK with Rust FSRS: $APK"
sha256sum "$APK"
