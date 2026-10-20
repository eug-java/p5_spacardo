# User Guide - Planned MVP

Status: DRAFT; features below are planned and NOT yet available in the Phase 0 demo.

## Getting started
1. Open the Android app, iOS app, or browser PWA.
2. Choose `Create deck`, enter a name, and select a note type (Basic, Reversed, Cloze).
3. Add notes with question and answer fields; optionally attach local images/audio and tags.
4. Open the deck and select `Study` to review due cards.

## Reviewing
Read the question, try to recall the answer, then reveal it. Choose Again, Hard, Good or Easy according to actual recall. Each choice updates the local spaced repetition schedule. Use Undo immediately after an accidental rating; suspending a card excludes it from the due queue until resumed.

## Importing Anki decks
Choose `Import`, select a supported `.apkg` package, review the inspection summary and warnings, and confirm import. Do not rely on arbitrary Anki JavaScript templates. Package variants outside the published compatibility matrix may fail or be imported with exclusions.

## Restoring a collection
Select a supported `.colpkg`, inspect and validate it, review the destructive replacement warning, and confirm a backup is available. Restoring a collection is not a merge of changes from several devices.

## Exporting and sharing
Select deck/collection export, choose supported settings and whether to include review history/media, then save the file using the platform file picker. For sharing a deck with another person, exclude your personal study history where possible.

## Backups and Web caution
Periodically save an external backup file. Browser-local data may disappear after clearing site storage or browser eviction; installing a PWA does not eliminate this risk. Always confirm that a backup can be restored before deleting a collection.

## Accessibility and offline
The finished app targets keyboard operation and screen reader support. Offline review should work after native install, or after the Web/PWA application resources are cached. Network/online status may affect first-time Web load and updates.
