"""SQLite contract regression for Phase 0.4 transaction semantics."""
import json
import re
import sqlite3
import unittest
from pathlib import Path

SCHEMA = Path(__file__).resolve().parents[1] / 'apps/mobile/lib/data/sql_schema.dart'

class ReviewTransactionTest(unittest.TestCase):
    def setUp(self):
        text = SCHEMA.read_text()
        raw = re.findall(r"'''(.*?)'''|'([^'\n]+)'", text, flags=re.S)
        self.db = sqlite3.connect(':memory:')
        for a, b in raw:
            sql = a or b
            if sql.strip().upper().startswith(('PRAGMA ', 'CREATE ')):
                self.db.execute(sql)
        self.db.execute("INSERT INTO decks(id,title,created_at_ms) VALUES ('d','Deck',0)")
        self.db.execute("INSERT INTO note_types(id,name,css) VALUES ('basic','Basic','')")
        self.db.execute("INSERT INTO notes(id,note_type_id,created_at_ms) VALUES ('n','basic',0)")
        self.db.execute("INSERT INTO cards(id,note_id,deck_id,template_ordinal) VALUES ('c','n','d',0)")
        self.db.execute("INSERT INTO card_states(card_id,phase) VALUES ('c','new')")

    def test_review_then_restore_preserves_state_and_audit(self):
        before = {'phase':'new','due_at_ms':None,'stability':None,'difficulty':None}
        after = {**before,'phase':'review','due_at_ms':259200001}
        with self.db:
            self.db.execute("UPDATE card_states SET phase=?,due_at_ms=? WHERE card_id='c'",(after['phase'],after['due_at_ms']))
            self.db.execute("INSERT INTO review_events(id,operation_id,card_id,reviewed_at_ms,rating,before_state_json,after_state_json) VALUES (?,?,?,?,?,?,?)",('r','op','c',1,3,json.dumps(before),json.dumps(after)))
        due = self.db.execute('SELECT due_at_ms FROM card_states WHERE card_id=?',('c',)).fetchone()[0]
        self.assertEqual(due,259200001)
        with self.db:
            stored = json.loads(self.db.execute("SELECT before_state_json FROM review_events WHERE operation_id='op'").fetchone()[0])
            self.db.execute("UPDATE card_states SET phase=?,due_at_ms=?,stability=?,difficulty=? WHERE card_id='c'",(stored['phase'],stored['due_at_ms'],stored['stability'],stored['difficulty']))
            self.db.execute("UPDATE review_events SET undone=1 WHERE operation_id='op'")
        self.assertEqual(self.db.execute("SELECT phase,due_at_ms FROM card_states WHERE card_id='c'").fetchone(),('new',None))
        self.assertEqual(self.db.execute("SELECT undone FROM review_events WHERE operation_id='op'").fetchone()[0],1)

    def test_duplicate_operation_rejected(self):
        data=('r','op','c',1,3,'{}','{}')
        self.db.execute('INSERT INTO review_events(id,operation_id,card_id,reviewed_at_ms,rating,before_state_json,after_state_json) VALUES (?,?,?,?,?,?,?)',data)
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.execute('INSERT INTO review_events(id,operation_id,card_id,reviewed_at_ms,rating,before_state_json,after_state_json) VALUES (?,?,?,?,?,?,?)',('r2',*data[1:]))

    def test_due_queue_filters_future_reviews(self):
        self.db.execute("UPDATE card_states SET due_at_ms=2000 WHERE card_id='c'")
        self.assertEqual(self.db.execute('SELECT COUNT(*) FROM card_states WHERE due_at_ms IS NULL OR due_at_ms<=?',(1000,)).fetchone()[0],0)
        self.assertEqual(self.db.execute('SELECT COUNT(*) FROM card_states WHERE due_at_ms IS NULL OR due_at_ms<=?',(2000,)).fetchone()[0],1)

if __name__ == '__main__': unittest.main()
