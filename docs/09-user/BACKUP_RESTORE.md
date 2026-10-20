# Backup and Restore - User and Developer Procedure

Status: PROPOSED; Phase 0 has not implemented full app backup.

## Backup content
A full native backup should contain the validated SQLite database snapshot, referenced local media, format version, checksums and relevant preferences. Exporting `.colpkg` is intended for Anki compatibility; a native `.ocbackup` or renamed product-specific backup format may preserve more application metadata.

## User backup steps (planned)
1. Navigate to `Settings > Backups`.
2. Select `Create backup` and wait for integrity verification.
3. Select `Export backup` and save it outside app/browser storage (external drive or user-chosen storage provider).
4. Record the filename/date and, when practical, verify restore using a separate test profile/device.

## User restore steps (planned)
1. Create a fresh backup of current data.
2. Choose `Restore backup` and select an externally stored file.
3. Read the summary, warnings, version compatibility and replacement impact.
4. Confirm restore only after validation; app must replace/activate data atomically.
5. Verify decks, note counts, media and a representative review history.

## Developer failure scenarios
Reject malformed archives, missing media required for integrity, unknown schema versions, insufficient storage, and checksum mismatch without damaging active data. Use staging and recovery. Record evidence for Android, iOS and Web.

## Web limitations
Local PWA backups stored in the same browser origin are not a safeguard against origin deletion. External export is required for durable recovery. Persistent storage permission does not guarantee indefinite storage retention.
