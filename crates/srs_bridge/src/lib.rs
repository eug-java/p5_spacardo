//! Stable, transport-neutral contract for a future Flutter Rust Bridge.
//! This crate contains no platform FFI glue. Native and WASM generation
//! must be verified with an installed Flutter and Rust toolchain.

/// Summarize an archive without extracting or trusting its contents.
/// This operation does NOT import cards or validate the embedded SQLite database.
pub fn inspect_package(input: &[u8]) -> Result<PackageInspection, String> {
    let result = srs_anki_codec::inspect_archive(input).map_err(|err| format!("{err:?}"))?;
    Ok(PackageInspection {
        entries: result.entries as u32,
        uncompressed_bytes: result.uncompressed_bytes,
        collection_file: result.collection_file,
        media_manifest_present: result.media_manifest_present,
    })
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PackageInspection {
    pub entries: u32,
    pub uncompressed_bytes: u64,
    pub collection_file: String,
    pub media_manifest_present: bool,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct CardMemory {
    pub stability: f32,
    pub difficulty: f32,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct NextReview {
    pub interval_days: f32,
    pub stability: f32,
    pub difficulty: f32,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ReviewChoices {
    pub again: NextReview,
    pub hard: NextReview,
    pub good: NextReview,
    pub easy: NextReview,
}

/// Preview the four FSRS choices. Does not persist a review.
pub fn preview_review(
    previous: Option<CardMemory>,
    elapsed_days: u32,
    desired_retention: f32,
) -> Result<ReviewChoices, String> {
    let previous = previous.map(|m| srs_fsrs::Memory {
        stability: m.stability,
        difficulty: m.difficulty,
    });
    let result = srs_fsrs::preview(previous, elapsed_days, desired_retention)
        .map_err(|err| format!("{err:?}"))?;
    fn map(value: srs_fsrs::Outcome) -> NextReview {
        NextReview {
            interval_days: value.interval_days,
            stability: value.next.stability,
            difficulty: value.next.difficulty,
        }
    }
    Ok(ReviewChoices {
        again: map(result.again),
        hard: map(result.hard),
        good: map(result.good),
        easy: map(result.easy),
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn bridge_contract_rejects_invalid_retention() {
        assert!(preview_review(None, 0, 1.1).is_err());
    }
    #[test]
    fn bridge_contract_rejects_bad_archive() {
        assert!(inspect_package(b"not a zip").is_err());
    }
}

pub mod ffi;
