"""Schema-level regression coverage for the Phase 0.3 basic-card workflow."""
import sqlite3
import unittest
from pathlib import Path


class BasicPracticeSchemaTest(unittest.TestCase):
    def setUp(self):
        import re
        source = (Path(__file__).resolve().parents[1] / 'apps/mobile/lib/data/sql_schema.dart').read_text()
        statements = re.findall(r"'''(.*?)'''|'([^'\n]+)'", source, flags=re.S)
        sql = [a or b for a, b in statements if (a or b).strip().upper().startswith(('PRAGMA ', 'CREATE '))]
        self.db = sqlite3.connect(':memory:')
        for statement in sql:
            self.db.execute(statement)
        self.db.execute("INSERT INTO decks(id,title,created_at_ms) VALUES ('d1','English',1)")
        self.db.execute("INSERT INTO note_types(id,name,css) VALUES ('basic','Basic','')")

    def tearDown(self):
        self.db.close()

    def test_basic_note_card_and_idempotent_review_event(self):
        self.db.execute("INSERT INTO notes(id,note_type_id,created_at_ms) VALUES ('n1','basic',1)")
        self.db.executemany('INSERT INTO note_fields(note_id,ordinal,value_html) VALUES (?,?,?)',
                            [('n1', 0, 'Apple'), ('n1', 1, 'Яблоко')])
        self.db.execute("INSERT INTO cards(id,note_id,deck_id,template_ordinal) VALUES ('c1','n1','d1',0)")
        self.db.execute("INSERT INTO card_states(card_id,phase) VALUES ('c1','new')")
        self.db.execute("INSERT OR IGNORE INTO review_events VALUES ('r1','op1','c1',123,3,'{}','{}',0)")
        self.db.execute("INSERT OR IGNORE INTO review_events VALUES ('r2','op1','c1',123,3,'{}','{}',0)")
        self.assertEqual(self.db.execute('SELECT COUNT(*) FROM review_events').fetchone()[0], 1)
        self.assertEqual(self.db.execute('SELECT COUNT(*) FROM note_fields WHERE note_id=?', ('n1',)).fetchone()[0], 2)
        self.assertEqual(self.db.execute('SELECT phase FROM card_states WHERE card_id=?', ('c1',)).fetchone()[0], 'new')

    def test_rating_constraint(self):
        self.db.execute("INSERT INTO notes(id,note_type_id,created_at_ms) VALUES ('n1','basic',1)")
        self.db.execute("INSERT INTO cards(id,note_id,deck_id,template_ordinal) VALUES ('c1','n1','d1',0)")
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.execute("INSERT INTO review_events VALUES ('r1','op1','c1',123,5,'{}','{}',0)")

if __name__ == '__main__':
    unittest.main()
