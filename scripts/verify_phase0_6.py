#!/usr/bin/env python3
"""Fail-closed Phase 0.6 source and configuration checks (not a build)."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
main=(ROOT/'apps/mobile/lib/main.dart').read_text()
db=(ROOT/'apps/mobile/lib/data/local_database.dart').read_text()
bridge=(ROOT/'crates/srs_bridge/src/lib.rs').read_text()
assert 'recordPractice(card.id, rating, operation)' not in main, 'Temporary scheduler still used by UI'
assert 'intervalMs = switch (rating)' not in db, 'Temporary interval calculation still present'
assert 'UnsupportedError(' in db and 'commitFsrsReview' in db
assert 'FSRS::default()' in (ROOT/'crates/srs_fsrs/src/lib.rs').read_text()
assert 'preview_review(' in bridge
assert (ROOT/'docs/04-development/PHASE0_6_STATUS.md').is_file()
print('Phase 0.6 source checks passed (not Flutter, Rust, or Web builds).')
