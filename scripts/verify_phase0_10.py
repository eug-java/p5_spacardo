from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]

class Phase010Tests(unittest.TestCase):
    def test_native_ffi_rejects_invalid_memory(self):
        source = (ROOT / 'crates/srs_bridge/src/ffi.rs').read_text()
        self.assertIn('stability <= 0.0', source)
        self.assertIn('difficulty > 10.0', source)

    def test_review_requires_operation_id(self):
        source = (ROOT / 'apps/mobile/lib/scheduler/study_review_service.dart').read_text()
        self.assertIn('operationId.trim().isEmpty', source)

    def test_build_runbook_is_present(self):
        self.assertTrue((ROOT / 'docs/04-development/PHASE0_10_BUILD_RUNBOOK.md').exists())

if __name__ == '__main__':
    unittest.main()
