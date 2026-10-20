/// Phase 0 schema prototype. Migrating and binding to the UI is pending.
/// This schema is validated in scripts/check_sql_schema.py using sqlite3.
const schemaV1 = <String>[
  'PRAGMA foreign_keys = ON',
  '''CREATE TABLE IF NOT EXISTS decks (
       id TEXT PRIMARY KEY NOT NULL,
       parent_id TEXT REFERENCES decks(id),
       title TEXT NOT NULL,
       created_at_ms INTEGER NOT NULL
     )''',
  '''CREATE TABLE IF NOT EXISTS note_types (
       id TEXT PRIMARY KEY NOT NULL,
       name TEXT NOT NULL,
       css TEXT NOT NULL DEFAULT ''
     )''',
  '''CREATE TABLE IF NOT EXISTS notes (
       id TEXT PRIMARY KEY NOT NULL,
       note_type_id TEXT NOT NULL REFERENCES note_types(id),
       anki_guid TEXT,
       created_at_ms INTEGER NOT NULL
     )''',
  '''CREATE TABLE IF NOT EXISTS note_fields (
       note_id TEXT NOT NULL REFERENCES notes(id) ON DELETE CASCADE,
       ordinal INTEGER NOT NULL,
       value_html TEXT NOT NULL,
       PRIMARY KEY (note_id, ordinal)
     )''',
  '''CREATE TABLE IF NOT EXISTS cards (
       id TEXT PRIMARY KEY NOT NULL,
       note_id TEXT NOT NULL REFERENCES notes(id) ON DELETE CASCADE,
       deck_id TEXT NOT NULL REFERENCES decks(id),
       template_ordinal INTEGER NOT NULL,
       suspended INTEGER NOT NULL DEFAULT 0 CHECK(suspended IN (0,1))
     )''',
  '''CREATE TABLE IF NOT EXISTS card_states (
       card_id TEXT PRIMARY KEY REFERENCES cards(id) ON DELETE CASCADE,
       phase TEXT NOT NULL CHECK(phase IN ('new','learning','review','relearning')),
       due_at_ms INTEGER,
       stability REAL,
       difficulty REAL
     )''',
  '''CREATE TABLE IF NOT EXISTS review_events (
       id TEXT PRIMARY KEY NOT NULL,
       operation_id TEXT UNIQUE NOT NULL,
       card_id TEXT NOT NULL REFERENCES cards(id) ON DELETE CASCADE,
       reviewed_at_ms INTEGER NOT NULL,
       rating INTEGER NOT NULL CHECK(rating BETWEEN 1 AND 4),
       before_state_json TEXT NOT NULL,
       after_state_json TEXT NOT NULL,
       undone INTEGER NOT NULL DEFAULT 0 CHECK(undone IN (0,1))
     )''',
  'CREATE INDEX IF NOT EXISTS ix_card_deck ON cards(deck_id)',
  'CREATE INDEX IF NOT EXISTS ix_card_due ON card_states(due_at_ms)',
  'CREATE INDEX IF NOT EXISTS ix_review_card_date ON review_events(card_id, reviewed_at_ms)',
];
