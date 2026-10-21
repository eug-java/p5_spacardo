# Phase 0.19 — dialog lifecycle regression tests

This patch adds a production-safe, explicitly test-only Flutter harness (`SpacardoTestHarness`) that uses an injected SQLite database. It does not modify FSRS, persistence schema, app entrypoint, or Android signing.

## Tests

- Deck: create, rename, cancel rename, cancel delete, delete.
- Card: create, edit, delete.
- Check for Flutter exceptions after dialog route closes.
- Uses `NativeDatabase.memory()`; no user data is opened.

Run:

```bash
cd apps/mobile
flutter analyze
flutter test test/dialog_lifecycle_widget_test.dart
SPACARDO_FSRS_LIBRARY="$(realpath ../../crates/target/release/libsrs_bridge.so)" flutter test
```

**Note:** This patch was prepared from the supplied source archive but could not be run here because Flutter/Dart SDKs are not installed in the preparation environment. If a widget finder fails for locale/layout reasons, provide the failing test output before committing.

## Scope intentionally excluded

- Renaming Android applicationId requires a separate migration decision (will change the app identity on device).
- The current Release APK uses debug signing per build.gradle.kts; it is **not** ready for Play Store publication.
- The diagnostic `Already watching path` message during Flutter builds did not prevent the supplied Release build from succeeding.
