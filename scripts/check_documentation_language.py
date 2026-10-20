#!/usr/bin/env python3
"""Check that repository documentation contains no Cyrillic script.

This is a basic language policy lint. It cannot prove that all text is good English.
"""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
CYRILLIC = re.compile(r"[\u0400-\u04FF]")
FILES = list(ROOT.rglob('*.md')) + list(ROOT.rglob('*.mdx'))
BAD = []
for path in FILES:
    if any(part in {'.git', 'build', '.dart_tool', 'node_modules'} for part in path.parts):
        continue
    content = path.read_text(encoding='utf-8')
    for number, line in enumerate(content.splitlines(), 1):
        if CYRILLIC.search(line):
            BAD.append(f"{path.relative_to(ROOT)}:{number}: Cyrillic character found")
if BAD:
    print('English documentation policy failed:\n' + '\n'.join(BAD))
    sys.exit(1)
print(f'English documentation character check passed: {len(FILES)} Markdown/MDX files scanned.')
