# P5 Spacardo - Phase 0.11 Validation

This incremental validation pack is intended for the existing Linux working tree. It does not overwrite the project or alter the user database.

## Prerequisites

Apply the previously provided Phase 0.11 source patch first, with your Flutter application closed. Keep a SQLite backup. Confirm the new deck rename and card management source files are present.

## Source checks

From `apps/mobile`:

```bash
dart format lib test
flutter analyze && flutter test
```

## Runtime checks

```bash
SPACARDO_FSRS_LIBRARY="/mnt/Terry/pet_project/p5_spacardo/crates/target/release/libsrs_bridge.so" flutter run -d linux
```

1. Rename a temporary deck and relaunch. Confirm its ID and cards remain unchanged.
2. Edit a temporary card, relaunch and verify its text and scheduling remain intact.
3. Delete a temporary card. Verify it remains deleted after relaunch.
4. Rate a card, relaunch and attempt Undo. Verify the card returns to its previous due state.
5. If any operation fails, preserve the terminal exception rather than deleting the database.

## Read-only SQLite diagnostic

Run the included script using the absolute or default database location:

```bash
python3 verify_spacardo_database.py "$HOME/Documents/p5_spacardo_phase0.sqlite"
```

`PRAGMA integrity_check` and `PRAGMA foreign_key_check` validate database structure and referential integrity. They do not prove that all FSRS intervals are algorithmically correct. The report prints deck names and card IDs but does not modify records; review content is not printed.

## Known limitations

Phase 0.11 runtime behavior is not yet verified by the project owner. Flutter/Rust toolchains are not installed in the packaging environment. The management labels are temporarily English-only, and Learning/Relearning scheduling remains incomplete. A successfully compiled interface is not proof of a correct Undo implementation after restart.
