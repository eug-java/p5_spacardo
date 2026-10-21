#!/usr/bin/env python3
"""Read-only SQLite integrity and scheduling diagnostics for P5 Spacardo.

Usage: python3 verify_spacardo_database.py [path/to/database.sqlite]
Never writes to the database. Uses SQLite immutable-independent read-only URI.
"""
from __future__ import annotations
import sqlite3
import sys
from pathlib import Path

DEFAULT = Path.home() / 'Documents/p5_spacardo_phase0.sqlite'
path = Path(sys.argv[1]).expanduser().resolve() if len(sys.argv) > 1 else DEFAULT
if not path.is_file():
    sys.exit(f'ERROR: Database not found: {path}')
conn = sqlite3.connect(path.as_uri() + '?mode=ro', uri=True)
try:
    conn.row_factory = sqlite3.Row
    tables = {r['name'] for r in conn.execute("SELECT name FROM sqlite_master WHERE type='table'")}
    required = {'decks', 'notes', 'note_fields', 'cards', 'card_states', 'review_events'}
    missing = required - tables
    if missing:
        sys.exit(f'ERROR: Missing tables: {sorted(missing)}')

    def fields(table: str) -> set[str]:
        return {r['name'] for r in conn.execute(f'PRAGMA table_info({table})')}

    print('Database:', path)
    fk_errors = conn.execute('PRAGMA foreign_key_check').fetchall()
    integrity = conn.execute('PRAGMA integrity_check').fetchone()[0]
    print('Foreign keys:', 'PASS' if not fk_errors else f'FAIL ({len(fk_errors)} problems)')
    print('Integrity:', integrity)
    for table in ['decks', 'notes', 'note_fields', 'cards', 'card_states', 'review_events']:
        print(f'{table:16} {conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]}')
    print('\nDecks:')
    for r in conn.execute('SELECT id, title FROM decks ORDER BY title'):
        print(f'  {r["id"]}  {r["title"]}')

    print('\nScheduling summary:')
    state_fields = fields('card_states')
    if {'due_at_ms', 'stability', 'difficulty'}.issubset(state_fields):
        states = conn.execute('''SELECT COUNT(*) total,
            SUM(CASE WHEN due_at_ms IS NULL THEN 1 ELSE 0 END) unscheduled,
            SUM(CASE WHEN stability IS NOT NULL AND difficulty IS NOT NULL THEN 1 ELSE 0 END) memory_set
            FROM card_states''').fetchone()
        print(f'  States: {states["total"]}; unscheduled: {states["unscheduled"] or 0}; memory set: {states["memory_set"] or 0}')
        bad = conn.execute('''SELECT COUNT(*) FROM card_states WHERE
            (stability IS NULL) <> (difficulty IS NULL)
            OR (stability IS NOT NULL AND stability <= 0)
            OR (difficulty IS NOT NULL AND (difficulty <= 0 OR difficulty > 10))''').fetchone()[0]
        print('  Memory constraints:', 'PASS' if bad == 0 else f'CHECK ({bad} suspicious states)')
    else:
        print('  Schema differs; skipped memory checks.')

    print('\nReview history:')
    event_fields = fields('review_events')
    if {'undone', 'operation_id', 'card_id'}.issubset(event_fields):
        r = conn.execute('''SELECT COUNT(*) total,
            SUM(CASE WHEN undone = 0 THEN 1 ELSE 0 END) active,
            SUM(CASE WHEN undone <> 0 THEN 1 ELSE 0 END) undone FROM review_events''').fetchone()
        print(f'  Total: {r["total"]}; active: {r["active"] or 0}; undone: {r["undone"] or 0}')
        duplicates = conn.execute('''SELECT COUNT(*) FROM (
            SELECT operation_id FROM review_events GROUP BY operation_id HAVING COUNT(*) > 1)''').fetchone()[0]
        print('  Unique operations:', 'PASS' if not duplicates else f'FAIL ({duplicates} duplicate IDs)')
        if {'reviewed_at_ms'}.issubset(event_fields):
            print('  Most recent active reviews:')
            for e in conn.execute('''SELECT c.deck_id, e.card_id, e.rating, e.reviewed_at_ms
                FROM review_events e JOIN cards c ON c.id=e.card_id
                WHERE e.undone=0 ORDER BY e.reviewed_at_ms DESC LIMIT 5'''):
                print(f'    deck={e["deck_id"]} card={e["card_id"]} rating={e["rating"]} at={e["reviewed_at_ms"]}')
    else:
        print('  Schema differs; skipped review summary.')
    if fk_errors or integrity != 'ok':
        sys.exit(1)
    print('\nRead-only verification: PASS')
finally:
    conn.close()
