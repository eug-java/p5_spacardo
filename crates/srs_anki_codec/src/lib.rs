//! Bounded ZIP metadata preflight, **not** a validated or feature-complete
//! APKG/COLPKG parser. No extraction and no execution of imported content.
use std::{collections::HashSet, io::Cursor};
use zip::ZipArchive;

const MAX_ARCHIVE_BYTES: usize = 256 * 1024 * 1024;
const MAX_ENTRIES: usize = 20_000;
const MAX_ENTRY_BYTES: u64 = 128 * 1024 * 1024;
const MAX_TOTAL_UNCOMPRESSED: u64 = 1024 * 1024 * 1024;

#[derive(Debug, Clone, PartialEq)]
pub struct ArchiveSummary {
    pub entries: usize,
    pub uncompressed_bytes: u64,
    pub collection_file: String,
    pub media_manifest_present: bool,
}

#[derive(Debug, Clone, PartialEq)]
pub enum AuditError {
    TooLarge,
    InvalidZip,
    TooManyEntries,
    UnsafeEntry(String),
    DuplicateEntry(String),
    OversizedContent,
    MissingCollection,
}

fn safe_path(p: &str) -> bool {
    if p.is_empty() || p.starts_with('/') || p.contains('\\') || p.contains('\0') {
        return false;
    }
    let mut segments = p.split('/');
    if segments.any(|part| part == "." || part == ".." || part.contains(':')) {
        return false;
    }
    true
}

pub fn inspect_archive(bytes: &[u8]) -> Result<ArchiveSummary, AuditError> {
    if bytes.len() > MAX_ARCHIVE_BYTES {
        return Err(AuditError::TooLarge);
    }
    let mut archive = ZipArchive::new(Cursor::new(bytes)).map_err(|_| AuditError::InvalidZip)?;
    if archive.len() > MAX_ENTRIES {
        return Err(AuditError::TooManyEntries);
    }
    let mut seen = HashSet::new();
    let mut total = 0u64;
    let mut collection = None;
    let mut media_manifest = false;
    for index in 0..archive.len() {
        let entry = archive
            .by_index(index)
            .map_err(|_| AuditError::InvalidZip)?;
        let name = entry.name().map_err(|_| AuditError::InvalidZip)?;
        let name = name.as_ref();
        if !safe_path(name)
            || entry.encrypted()
            || entry
                .unix_mode()
                .map(|m| m & 0o170000 == 0o120000)
                .unwrap_or(false)
        {
            return Err(AuditError::UnsafeEntry(name.into()));
        }
        if !seen.insert(name.to_owned()) {
            return Err(AuditError::DuplicateEntry(name.into()));
        }
        if entry.size() > MAX_ENTRY_BYTES {
            return Err(AuditError::OversizedContent);
        }
        total = total
            .checked_add(entry.size())
            .ok_or(AuditError::OversizedContent)?;
        if total > MAX_TOTAL_UNCOMPRESSED {
            return Err(AuditError::OversizedContent);
        }
        if matches!(
            name,
            "collection.anki2" | "collection.anki21" | "collection.anki21b"
        ) {
            collection = Some(name.to_owned());
        }
        if name == "media" {
            media_manifest = true;
        }
    }
    Ok(ArchiveSummary {
        entries: archive.len(),
        uncompressed_bytes: total,
        collection_file: collection.ok_or(AuditError::MissingCollection)?,
        media_manifest_present: media_manifest,
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn empty_file_is_not_zip() {
        assert_eq!(inspect_archive(&[]), Err(AuditError::InvalidZip));
    }
    #[test]
    fn oversized_input_is_rejected() {
        assert_eq!(
            inspect_archive(&vec![0u8; MAX_ARCHIVE_BYTES + 1]),
            Err(AuditError::TooLarge)
        );
    }
    #[test]
    fn unsafe_paths_are_rejected() {
        assert!(!safe_path("../../private"));
        assert!(!safe_path("/root/foo"));
        assert!(!safe_path("C:/root/foo"));
        assert!(!safe_path("a\\b"));
        assert!(safe_path("collection.anki21b"));
    }
}
