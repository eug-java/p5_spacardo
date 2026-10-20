# Data Model and Migrations

Version: 0.2. Status: PROPOSED.

## Core separation
A Note contains fields and tags. A Card is a rendered study item generated from a note type/template. For a reversible translation note, one Note may produce two Cards; every Card has its own scheduling state and review history.

## Proposed tables
| Table | Relevant columns | Notes |
| --- | --- | --- |
| `decks` | uuid, parent_uuid, name, preset_uuid | Hierarchical decks |
| `note_types` | uuid, name, kind, css | Basic/Reversed/Cloze |
| `note_fields` | note_type_uuid, ordinal, name | Schema definition |
| `card_templates` | note_type_uuid, ordinal, question_html, answer_html | Render rules |
| `notes` | uuid, anki_guid, note_type_uuid, updated_at | Source content |
| `note_values` | note_uuid, ordinal, value | Per-note fields |
| `cards` | uuid, note_uuid, deck_uuid, template_ordinal | Study items |
| `card_states` | card_uuid, stability, difficulty, due_at, state, suspended | Current FSRS state |
| `review_events` | uuid, card_uuid, rating, reviewed_at, old_state, new_state | Audit/undo |
| `scheduler_presets` | uuid, fsrs_version, parameters, desired_retention | Reproducibility |
| `media` | uuid, logical_name, hash, type, storage_key | Never absolute paths |
| `tags` / `note_tags` | uuid, note_uuid, tag_uuid | Lookup |
| `import_jobs` | uuid, file_hash, status, report | Replay and diagnostics |
| `anki_identity_map` | collection_id, anki_id, object_uuid, kind | Source identity |
| `schema_migrations` | version, applied_at | Deterministic upgrades |

The actual starter SQL schema is in `apps/mobile/lib/data/sql_schema.dart`; the proposed model above is a target and may not yet match scaffolded tables exactly.

## Migration and integrity requirements
- Enable foreign keys; native SQLite may use WAL where supported; browser storage has platform-specific locking rules.
- Store UTC instants and an explicit local-day boundary preference; never rely only on host local timestamps.
- Apply schema changes via numbered, repeatable migrations; create backup before destructive migrations.
- Use an idempotent review operation UUID and unique constraints for duplicate suppression.
- Preserve external Anki identifiers separately; they are not globally unique across unrelated collections.
- Never overwrite review history on duplicate import without user approval.
- Roll back full import transaction on validation or write failure.

## Storage tests
Validate foreign keys, idempotent review application, migration from every supported schema version, interrupted import recovery, and browser multi-tab coordination. Document any unsupported storage engine or browser version explicitly.
