#!/usr/bin/env python3
# Smoke-test SQLite DDL mirrored from Dart; no dependencies.
from pathlib import Path
import re
import sqlite3

def statements_from_dart(path: Path):
    text = path.read_text(encoding="utf-8")
    return re.findall(r"'''(.*?)'''|'(CREATE INDEX.*?)'|'(PRAGMA.*?)'", text, flags=re.S)

def main():
    schema = Path(__file__).resolve().parents[1]/'apps/mobile/lib/data/sql_schema.dart'
    conn = sqlite3.connect(':memory:')
    flat = []
    for chunk in statements_from_dart(schema):
        statement = next(p for p in chunk if p)
        flat.append(statement)
        conn.execute(statement)
    assert len(flat) >= 10, f'Expected >=10 DDL/PRAGMA statements, found {len(flat)}'
    conn.execute("INSERT INTO decks VALUES ('d1', NULL, 'English', 0)")
    conn.execute("INSERT INTO note_types VALUES ('t1','Basic','')")
    conn.execute("INSERT INTO notes VALUES ('n1','t1',NULL,0)")
    conn.execute("INSERT INTO cards VALUES ('c1','n1','d1',0,0)")
    conn.execute("INSERT INTO card_states VALUES ('c1','new',NULL,NULL,NULL)")
    try:
        conn.execute("INSERT INTO card_states VALUES ('c2','new',NULL,NULL,NULL)")
        raise AssertionError('FK constraint not enforced')
    except sqlite3.IntegrityError:
        pass
    print(f'PASS SQLite DDL smoke: {len(flat)} statements; FK enforced')

if __name__=='__main__': main()
