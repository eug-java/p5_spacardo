# Threat Model - Local User Data and Untrusted Decks

Status: PROPOSED. Review before public release.

## Assets and entry points
Assets: notes, cards, review history, backup archives, settings, device storage and browser origin storage. Untrusted input: APKG/COLPKG/CSV and embedded images/audio/HTML/CSS, malformed ZIP/SQLite, import filenames, and navigation URLs.

## Primary risks and controls
| Threat | Control |
| --- | --- |
| ZIP path traversal | Normalize paths; reject absolute paths, `..`, separators in media names when unsafe |
| ZIP bomb | Maximum expanded bytes, member count, compression ratio, and per-file limits |
| Malformed SQLite | Integrity check, read-only staged parsing, bounded queries, schema version validation |
| WebView/script injection | Sanitize card content; disable privileged JS bridge and uncontrolled navigation |
| External fetch/tracking in cards | Block external URLs and remote resources by default |
| Media parser vulnerability | Limit supported types/sizes and use platform-safe decoders |
| Data loss on import | Stage, transaction, backup before destructive restore |
| Duplicate reviews | Idempotency key plus unique constraint |
| Browser eviction | Explicit external backup prompts and storage quota checks |
| Multi-tab concurrent writes | Single-writer lock/coordination protocol |
| Dependency compromise | Pinned versions, provenance, lock files, dependency audit and code review |
| Sensitive logs | Avoid recording user note fields, decks or file content |

## Security testing
Include malformed and adversarial archives, decompression limits, unusual filenames, invalid Unicode, large media, unsupported JavaScript templates, aborted imports, low disk space, and browser tab contention. Document chosen thresholds after profiling.

## Privacy limitations
On-device data is not equivalent to encryption-at-rest on every device. Platform backups, browser data deletion, hosting access logs and third-party delivery of assets must be assessed and disclosed accurately.
