#!/usr/bin/env python3
"""Safe-ish ZIP central-directory metadata preflight for developer diagnostics.

This does NOT decompress archives or establish Anki import/export compatibility.
Archive size and entry restrictions are intentional; use streaming import in app.
"""
from __future__ import annotations

import argparse
from dataclasses import asdict, dataclass
import json
from pathlib import Path, PurePosixPath
import stat
import sys
import zipfile

MAX_ARCHIVE = 256 * 1024 * 1024
MAX_ENTRIES = 20_000
MAX_ENTRY = 128 * 1024 * 1024
MAX_TOTAL_UNCOMPRESSED = 1024 * 1024 * 1024
COLLECTIONS = ("collection.anki21b", "collection.anki21", "collection.anki2")


class PackageAuditError(ValueError):
    pass


@dataclass(frozen=True)
class ArchiveSummary:
    collection_member: str
    entries: int
    uncompressed_bytes: int
    media_manifest_present: bool
    warnings: tuple[str, ...]


def _validate_name(name: str) -> None:
    if not name or name.startswith("/") or "\\" in name or "\x00" in name:
        raise PackageAuditError(f"Unsafe archive member path: {name!r}")
    parts = name.split("/")
    if any(x in ("..", ".") or ":" in x for x in parts):
        raise PackageAuditError(f"Unsafe archive member path: {name!r}")
    # Zip directory names legitimately have a single terminal slash.
    if any(not part for part in parts[:-1]):
        raise PackageAuditError(f"Unsafe archive member path: {name!r}")


def inspect(path: str | Path) -> ArchiveSummary:
    p = Path(path)
    if p.suffix.lower() not in {".apkg", ".colpkg"}:
        raise PackageAuditError("Expected .apkg or .colpkg")
    if not p.is_file():
        raise PackageAuditError("File not found")
    if p.stat().st_size > MAX_ARCHIVE:
        raise PackageAuditError("Archive is larger than the Phase 0 limit")
    try:
        with zipfile.ZipFile(p, "r") as z:
            info = z.infolist()
            if len(info) > MAX_ENTRIES:
                raise PackageAuditError("Too many archive entries")
            total = 0
            seen: set[str] = set()
            for entry in info:
                _validate_name(entry.filename)
                if entry.filename in seen:
                    raise PackageAuditError("Duplicate member path")
                seen.add(entry.filename)
                if entry.flag_bits & 1:
                    raise PackageAuditError("Encrypted ZIP entry")
                mode = (entry.external_attr >> 16) & 0xFFFF
                if stat.S_IFMT(mode) == stat.S_IFLNK:
                    raise PackageAuditError("Symbolic link entry")
                if entry.file_size > MAX_ENTRY:
                    raise PackageAuditError("Oversized entry")
                total += entry.file_size
                if total > MAX_TOTAL_UNCOMPRESSED:
                    raise PackageAuditError("Uncompressed size limit exceeded")
            col = next((c for c in COLLECTIONS if c in seen), None)
            if col is None:
                raise PackageAuditError("No supported collection filename in ZIP root")
            warnings = []
            if sum(c in seen for c in COLLECTIONS) > 1:
                warnings.append("Multiple collection variants; format selection requires full importer")
            if "media" not in seen:
                warnings.append("No media manifest")
            warnings.append("Metadata-only preflight: not validated as Anki data")
            return ArchiveSummary(col, len(info), total, "media" in seen, tuple(warnings))
    except (zipfile.BadZipFile, zipfile.LargeZipFile, EOFError, OSError) as exc:
        raise PackageAuditError("Corrupt or unsupported ZIP container") from exc


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("archive", type=Path)
    args = parser.parse_args()
    try:
        summary = inspect(args.archive)
    except PackageAuditError as e:
        print(json.dumps({"status": "rejected", "reason": str(e)}, ensure_ascii=False))
        return 2
    print(json.dumps({"status": "metadata_ok", **asdict(summary)}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
