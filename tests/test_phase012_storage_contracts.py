"""Phase 0.12 SQLite contract tests. Uses an in-memory database only.

These tests verify schema constraints and intended SQL transaction semantics.
They do not execute Flutter/Drift or native FSRS code.
"""
import json
import re
import sqlite3
import unittest
from pathlib import Path

SCHEMA = Path(__file__).resolve().parents[1] / 'apps/mobile/lib/data/sql_schema.dart'


def create_database():
    source = SCHEMA.read_text(encoding='utf-8')
    statements = re.findall(r"'''(.*?)'''|'([^'\n]+)'", source, flags=re.S)
    db = sqlite3.connect(':memory:')
    for multiline, single in statements:
        sql = multiline or single
        if sql.strip().upper().startswith(('PRAGMA ', 'CREATE ')):
            db.execute(sql)
    db.execute('PRAGMA foreign_keys = ON')
    return db


class StorageContracts(unittest.TestCase):
    def setUp(self):
        self.db = create_database()
        self.add_deck('a', 'Old title')
        self.add_deck('b', 'Other deck')
        self.db.execute("INSERT INTO note_types(id,name,css) VALUES ('basic','Basic','')")

    def tearDown(self):
        self.db.close()

    def add_deck(self, deck_id, title, parent=None):
        self.db.execute(
            'INSERT INTO decks(id,parent_id,title,created_at_ms) VALUES (?,?,?,0)',
            (deck_id, parent, title),
        )

    def add_card(self, card_id, note_id, deck_id):
        self.db.execute('INSERT OR IGNORE INTO notes(id,note_type_id,created_at_ms) VALUES (?,\'basic\',0)', (note_id,))
        self.db.execute('INSERT INTO cards(id,note_id,deck_id,template_ordinal) VALUES (?,?,?,0)', (card_id, note_id, deck_id))
        self.db.execute('INSERT INTO card_states(card_id,phase,due_at_ms,stability,difficulty) VALUES (?,\'review\',999,2.5,3.3)', (card_id,))
        self.db.execute('INSERT OR IGNORE INTO note_fields(note_id,ordinal,value_html) VALUES (?,0,\'Front\')', (note_id,))
        self.db.execute('INSERT OR IGNORE INTO note_fields(note_id,ordinal,value_html) VALUES (?,1,\'Back\')', (note_id,))

    def delete_deck_transaction(self, deck_id):
        """Mirrors the expected child-protected deck deletion SQL contract."""
        self.db.commit()  # Commit test fixtures before testing transaction rollback.
        with self.db:
            if self.db.execute('SELECT 1 FROM decks WHERE parent_id=? LIMIT 1', (deck_id,)).fetchone():
                raise ValueError('child decks exist')
            note_ids = [row[0] for row in self.db.execute('SELECT DISTINCT note_id FROM cards WHERE deck_id=?', (deck_id,))]
            self.db.execute('DELETE FROM review_events WHERE card_id IN (SELECT id FROM cards WHERE deck_id=?)', (deck_id,))
            self.db.execute('DELETE FROM card_states WHERE card_id IN (SELECT id FROM cards WHERE deck_id=?)', (deck_id,))
            self.db.execute('DELETE FROM cards WHERE deck_id=?', (deck_id,))
            for note_id in note_ids:
                if not self.db.execute('SELECT 1 FROM cards WHERE note_id=? LIMIT 1', (note_id,)).fetchone():
                    self.db.execute('DELETE FROM note_fields WHERE note_id=?', (note_id,))
                    self.db.execute('DELETE FROM notes WHERE id=?', (note_id,))
            self.db.execute('DELETE FROM decks WHERE id=?', (deck_id,))

    def test_rename_preserves_card_and_scheduling_state(self):
        self.add_card('ca', 'n1', 'a')
        before = self.db.execute('SELECT phase,due_at_ms,stability,difficulty FROM card_states WHERE card_id=\'ca\'').fetchone()
        with self.db:
            self.db.execute('UPDATE decks SET title=? WHERE id=?', ('New title', 'a'))
        self.assertEqual(self.db.execute('SELECT title FROM decks WHERE id=\'a\'').fetchone()[0], 'New title')
        self.assertEqual(self.db.execute('SELECT phase,due_at_ms,stability,difficulty FROM card_states WHERE card_id=\'ca\'').fetchone(), before)

    def test_deleting_deck_cleans_unshared_card_and_audit(self):
        self.add_card('ca', 'n1', 'a')
        self.db.execute('INSERT INTO review_events(id,operation_id,card_id,reviewed_at_ms,rating,before_state_json,after_state_json) VALUES (\'r1\',\'o1\',\'ca\',1,3,\'{}\',\'{}\')')
        self.delete_deck_transaction('a')
        for table in ('cards', 'card_states', 'review_events', 'notes', 'note_fields'):
            self.assertEqual(self.db.execute(f'SELECT count(*) FROM {table}').fetchone()[0], 0, table)
        self.assertEqual(self.db.execute('PRAGMA foreign_key_check').fetchall(), [])

    def test_shared_note_survives_deck_removal(self):
        self.add_card('ca', 'shared', 'a')
        self.add_card('cb', 'shared', 'b')
        self.delete_deck_transaction('a')
        self.assertEqual(self.db.execute('SELECT count(*) FROM notes').fetchone()[0], 1)
        self.assertEqual(self.db.execute('SELECT count(*) FROM note_fields').fetchone()[0], 2)
        self.assertEqual(self.db.execute('SELECT deck_id FROM cards WHERE id=\'cb\'').fetchone()[0], 'b')
        self.assertEqual(self.db.execute('PRAGMA foreign_key_check').fetchall(), [])

    def test_child_deck_deletion_is_blocked(self):
        self.add_deck('child', 'Child', parent='a')
        with self.assertRaises(ValueError):
            self.delete_deck_transaction('a')
        self.assertEqual(self.db.execute('SELECT count(*) FROM decks').fetchone()[0], 3)

    def test_last_active_review_can_be_restored_after_reopen(self):
        self.add_card('ca', 'n1', 'a')
        before = {'phase': 'new', 'due_at_ms': None, 'stability': None, 'difficulty': None}
        after = {'phase': 'review', 'due_at_ms': 999, 'stability': 2.5, 'difficulty': 3.3}
        self.db.execute('INSERT INTO review_events(id,operation_id,card_id,reviewed_at_ms,rating,before_state_json,after_state_json) VALUES (?,?,?,?,?,?,?)', ('r1', 'o1', 'ca', 1000, 3, json.dumps(before), json.dumps(after)))
        self.db.execute('INSERT INTO review_events(id,operation_id,card_id,reviewed_at_ms,rating,before_state_json,after_state_json) VALUES (?,?,?,?,?,?,?)', ('r2', 'o2', 'ca', 1100, 3, json.dumps(after), json.dumps(after)))
        candidate = self.db.execute('SELECT operation_id,card_id,before_state_json FROM review_events WHERE undone=0 ORDER BY reviewed_at_ms DESC, rowid DESC LIMIT 1').fetchone()
        self.assertEqual(candidate[0], 'o2')
        with self.db:
            prev = json.loads(candidate[2])
            self.db.execute('UPDATE card_states SET phase=?,due_at_ms=?,stability=?,difficulty=? WHERE card_id=?', (*[prev[k] for k in ('phase', 'due_at_ms', 'stability', 'difficulty')], candidate[1]))
            self.db.execute('UPDATE review_events SET undone=1 WHERE operation_id=?', (candidate[0],))
        self.assertEqual(self.db.execute('SELECT undone FROM review_events WHERE operation_id=\'o2\'').fetchone()[0], 1)
        self.assertEqual(self.db.execute('SELECT stability FROM card_states WHERE card_id=\'ca\'').fetchone()[0], 2.5)


if __name__ == '__main__':
    unittest.main()
