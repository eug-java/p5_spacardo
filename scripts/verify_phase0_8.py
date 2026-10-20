#!/usr/bin/env python3
"""Static presence checks only; does not claim Flutter/Rust compilation."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
service = (root / 'apps/mobile/lib/scheduler/study_review_service.dart').read_text()
main = (root / 'apps/mobile/lib/main.dart').read_text()
db = (root / 'apps/mobile/lib/data/local_database.dart').read_text()
assert 'engine.preview(' in service
assert 'commitFsrsReview(' in service
assert 'getStudySnapshot(cardId)' in service
assert 'createFsrsEngine()' in main
assert 'StudyReviewService(widget.database, engine).answer(' in main
assert 'SELECT MAX(reviewed_at_ms)' in db
assert 'expectedReviewCount: snapshot.reviewCount' in service
assert 'No heuristic fallback' in (root / 'docs/04-development/PHASE0_8_STATUS.md').read_text()
print('Phase 0.8 static integration checks: OK (NOT a build test)')
