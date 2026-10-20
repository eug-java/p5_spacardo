import tempfile
import unittest
from pathlib import Path
import zipfile

from tools.anki_archive_audit import inspect, PackageAuditError


class ArchiveAuditTests(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.TemporaryDirectory()
        self.addCleanup(self.dir.cleanup)
        self.path = Path(self.dir.name) / 'fixture.apkg'

    def create(self, files):
        with zipfile.ZipFile(self.path, 'w', compression=zipfile.ZIP_DEFLATED) as z:
            for filename, data in files:
                z.writestr(filename, data)

    def test_minimal_legacy_zip_metadata(self):
        self.create([('collection.anki2', b'SQLite format 3\0'), ('media', b'{}')])
        v = inspect(self.path)
        self.assertEqual(v.collection_member, 'collection.anki2')
        self.assertTrue(v.media_manifest_present)

    def test_modern_variant_preferred(self):
        self.create([('collection.anki2', b''), ('collection.anki21b', b'dummy')])
        v = inspect(self.path)
        self.assertEqual(v.collection_member, 'collection.anki21b')
        self.assertGreater(len(v.warnings), 1)

    def test_missing_collection_rejected(self):
        self.create([('media', '{}')])
        with self.assertRaisesRegex(PackageAuditError, 'No supported collection'):
            inspect(self.path)

    def test_zip_slip_rejected(self):
        self.create([('collection.anki2', b''), ('../outside', b'evil')])
        with self.assertRaisesRegex(PackageAuditError, 'Unsafe'):
            inspect(self.path)

    def test_backslash_and_drive_path_rejected(self):
        for bad_path in ('..\\hidden', 'C:/passwd', '/etc/passwd', 'x//y'):
            with self.subTest(bad_path=bad_path):
                self.create([('collection.anki2', b''), (bad_path, b'evil')])
                with self.assertRaisesRegex(PackageAuditError, 'Unsafe'):
                    inspect(self.path)

    def test_duplicate_rejected(self):
        self.create([('collection.anki2', b''), ('collection.anki2', b'')])
        with self.assertRaisesRegex(PackageAuditError, 'Duplicate'):
            inspect(self.path)

    def test_symlink_rejected(self):
        link = zipfile.ZipInfo('link')
        link.create_system = 3
        link.external_attr = (0o120777 << 16)
        with zipfile.ZipFile(self.path, 'w') as z:
            z.writestr('collection.anki2', b'')
            z.writestr(link, b'/etc/passwd')
        with self.assertRaisesRegex(PackageAuditError, 'Symbolic link'):
            inspect(self.path)

    def test_invalid_zip_rejected(self):
        self.path.write_bytes(b'not a zip')
        with self.assertRaisesRegex(PackageAuditError, 'Corrupt'):
            inspect(self.path)

    def test_wrong_extension_rejected(self):
        path = Path(self.dir.name) / 'fixture.zip'
        path.write_bytes(b'fake')
        with self.assertRaisesRegex(PackageAuditError, 'Expected'):
            inspect(path)

    def test_archive_over_size_rejected_from_metadata(self):
        info = zipfile.ZipInfo('evil.bin')
        with zipfile.ZipFile(self.path, 'w') as z:
            z.writestr('collection.anki2', b'')
            z.writestr(info, b'content')
        # This test guards the constant condition without allocating a huge blob
        from unittest.mock import patch
        with patch('tools.anki_archive_audit.MAX_ENTRY', 3):
            with self.assertRaisesRegex(PackageAuditError, 'Oversized'):
                inspect(self.path)


if __name__ == '__main__':
    unittest.main()
