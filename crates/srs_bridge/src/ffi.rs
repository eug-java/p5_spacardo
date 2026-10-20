//! Versioned native C ABI for FSRS preview. Experimental until device validation.
//! This is intentionally separate from the transport-neutral Rust API.
use std::panic::{catch_unwind, AssertUnwindSafe};
use crate::{preview_review, CardMemory, NextReview};

/// C-compatible, fixed-size output. All floats are IEEE-754 32-bit values.
#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
pub struct FsrsOptionC {
    pub interval_days: f32,
    pub stability: f32,
    pub difficulty: f32,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default)]
pub struct FsrsPreviewC {
    pub again: FsrsOptionC,
    pub hard: FsrsOptionC,
    pub good: FsrsOptionC,
    pub easy: FsrsOptionC,
}

/// 0=OK, 1=null pointer, 2=invalid input, 3=engine error/panic.
/// `has_previous=0` ignores previous memory. Do not pass an invalid pointer.
#[no_mangle]
pub extern "C" fn spacardo_fsrs_preview_v1(
    has_previous: u8,
    stability: f32,
    difficulty: f32,
    elapsed_days: u32,
    retention: f32,
    out: *mut FsrsPreviewC,
) -> i32 {
    if out.is_null() { return 1; }
    if has_previous > 1 { return 2; }
    if has_previous == 1 && (!stability.is_finite() || stability <= 0.0
        || !difficulty.is_finite() || difficulty <= 0.0 || difficulty > 10.0) { return 2; }
    let result = catch_unwind(AssertUnwindSafe(|| {
        let previous = if has_previous == 1 {
            Some(CardMemory { stability, difficulty })
        } else { None };
        preview_review(previous, elapsed_days, retention)
    }));
    match result {
        Ok(Ok(v)) => {
            fn convert(o: NextReview) -> FsrsOptionC {
                FsrsOptionC { interval_days: o.interval_days, stability: o.stability, difficulty: o.difficulty }
            }
            // Safety: caller must provide a writable FsrsPreviewC. This ABI is only
            // called through a typed FFI wrapper and is not safe for arbitrary pointers.
            unsafe { *out = FsrsPreviewC {
                again: convert(v.again), hard: convert(v.hard),
                good: convert(v.good), easy: convert(v.easy),
            }; }
            0
        }
        Ok(Err(_)) => 2,
        Err(_) => 3,
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn native_abi_produces_valid_choices() {
        let mut output = FsrsPreviewC::default();
        assert_eq!(spacardo_fsrs_preview_v1(0, 0., 0., 0, 0.9, &mut output), 0);
        assert!(output.good.stability > 0.);
        assert_eq!(spacardo_fsrs_preview_v1(0, 0., 0., 0, 0.9, std::ptr::null_mut()), 1);
        assert_eq!(spacardo_fsrs_preview_v1(0, 0., 0., 0, 1.2, &mut output), 2);
    }
}
