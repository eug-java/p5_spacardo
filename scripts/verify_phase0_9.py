#!/usr/bin/env python3
"""Source-level integration guards (not a replacement for Flutter/Rust builds)."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
ffi=(root/'crates/srs_bridge/src/ffi.rs').read_text()
native=(root/'apps/mobile/lib/scheduler/native_fsrs.dart').read_text()
factory=(root/'apps/mobile/lib/scheduler/scheduler_factory_native.dart').read_text()
db=(root/'apps/mobile/lib/data/local_database.dart').read_text()
assert 'use crate::{preview_review, CardMemory, NextReview};' in ffi
assert 'catch_unwind' in ffi
assert 'Native FSRS returned invalid values' in native
assert 'Platform.isAndroid' in factory and 'Platform.isIOS' in factory
assert 'An undone operation ID cannot be reused' in db
assert 'Review time is older than active history' in db
assert (root/'docs/04-development/PHASE0_9_STATUS.md').exists()
print('Phase 0.9 source guards: PASS (not a compilation test)')
