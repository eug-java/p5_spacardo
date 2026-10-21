# P5 Spacardo - Phase 0.11 source patch

This is an incremental patch for the user's existing, working `apps/mobile` checkout, not a full project archive. It preserves the custom Linux Rust FSRS library loader, Flutter localization fixes, native runner, and installed Flutter SDK.

## Changes

- Rename a deck from a pencil icon, without changing its ID or scheduling data.
- Inspect **all** cards in the selected deck, including cards whose due date is in the future.
- Edit a Basic card's front/back fields without resetting its review history.
- Delete a Basic card and its review history in one SQLite transaction, with a confirmation dialog.
- Show the stored due date in a dedicated card-management list.
- Restore the latest active review's Undo button when loading a deck after restart. Undo uses the existing `undoLastReview` implementation.

## Safety and limitations

- Close the application before backing up and modifying its source files.
- Before applying, back up the SQLite database using the SQLite backup API. The patch program itself does not open or modify the database.
- The installer creates `.bak_<timestamp>` backups of both modified Dart source files.
- This patch expects the previously applied deck deletion feature and fails without it. It also refuses to apply twice.
- Card edits are refused when a note is shared by multiple cards, to avoid unexpected cross-card mutations.
- Deleting a card permanently deletes its related review events and FSRS state. This action is not reversible through the review Undo command.
- Restored Undo applies to the latest active review in a deck, and its result still needs Flutter runtime verification. The button is not a general multi-step undo history.
- Displayed due dates are local device time. FSRS Learning/Relearning steps and WebAssembly integration are still pending.
- The new management UI uses temporary English-only labels. Full 18-locale translation is still pending.
- No Flutter or Rust compilation was possible in the packaging environment. Do not claim those tests passed until running them locally.

## Installation

Run from `apps/mobile` in your P5 Spacardo project:

```bash
python3 /path/to/p5_spacardo_phase0_11_patch.py

dart format lib/main.dart lib/data/local_database.dart
flutter analyze
flutter test
```

If these pass, launch your app with the known working Rust library path:

```bash
SPACARDO_FSRS_LIBRARY="/mnt/Terry/pet_project/p5_spacardo/crates/target/release/libsrs_bridge.so" \
flutter run -d linux
```

Test editing a new temporary deck and card before editing existing user content.

## Suggested manual verification

1. Rename a deck, close/relaunch, verify the new title and existing cards remain.
2. Edit a card, close/relaunch, verify the text changes without resetting its stored due date.
3. Delete a temporary card, close/relaunch, verify it remains deleted.
4. Grade Good, close/relaunch, verify Undo appears, press Undo, verify due scheduling changes.
5. Run `PRAGMA foreign_key_check` and `PRAGMA integrity_check` on the SQLite database.
