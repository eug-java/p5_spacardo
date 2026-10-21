//! Pure scheduling preview port. No I/O and no database mutation.
//! Production learning/relearning steps and migration are not implemented.
use fsrs::{MemoryState, FSRS};

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Memory {
    pub stability: f32,
    pub difficulty: f32,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Outcome {
    pub interval_days: f32,
    pub next: Memory,
}

#[derive(Debug, Clone, PartialEq)]
pub struct RatingOptions {
    pub again: Outcome,
    pub hard: Outcome,
    pub good: Outcome,
    pub easy: Outcome,
}

#[derive(Debug, Clone, PartialEq)]
pub enum ScheduleError {
    InvalidRetention,
    InvalidState,
    Engine(String),
}

fn convert(state: fsrs::ItemState) -> Outcome {
    Outcome {
        interval_days: state.interval,
        next: Memory {
            stability: state.memory.stability,
            difficulty: state.memory.difficulty,
        },
    }
}

/// Return all four possible FSRS outcomes, without persisting any of them.
/// `elapsed_days` is the whole day difference required by FSRS-rs's API;
/// sub-day learning steps are a separate application-layer responsibility.
pub fn preview(
    previous: Option<Memory>,
    elapsed_days: u32,
    desired_retention: f32,
) -> Result<RatingOptions, ScheduleError> {
    if !desired_retention.is_finite() || !(0.7..=0.99).contains(&desired_retention) {
        return Err(ScheduleError::InvalidRetention);
    }
    if let Some(p) = previous {
        if !p.stability.is_finite()
            || !p.difficulty.is_finite()
            || p.stability <= 0.0
            || p.difficulty <= 0.0
            || p.difficulty > 10.0
        {
            return Err(ScheduleError::InvalidState);
        }
    }
    let previous = previous.map(|p| MemoryState {
        stability: p.stability,
        difficulty: p.difficulty,
    });
    let states = FSRS::default()
        .next_states(previous, desired_retention, elapsed_days)
        .map_err(|e| ScheduleError::Engine(e.to_string()))?;
    Ok(RatingOptions {
        again: convert(states.again),
        hard: convert(states.hard),
        good: convert(states.good),
        easy: convert(states.easy),
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn first_review_has_four_finite_outcomes() {
        let choices = preview(None, 0, 0.90).expect("valid schedule");
        for c in [choices.again, choices.hard, choices.good, choices.easy] {
            assert!(c.interval_days.is_finite());
            assert!(c.next.stability.is_finite());
            assert!(c.next.stability > 0.0);
        }
    }

    #[test]
    fn invalid_retention_rejected() {
        assert_eq!(
            preview(None, 0, f32::NAN),
            Err(ScheduleError::InvalidRetention)
        );
        assert_eq!(preview(None, 0, 1.0), Err(ScheduleError::InvalidRetention));
    }

    #[test]
    fn deterministic_preview() {
        let first = preview(None, 0, 0.9).expect("valid schedule");
        let second = preview(None, 0, 0.9).expect("valid schedule");
        assert_eq!(first, second);
        let follow_up = preview(Some(first.good.next), 7, 0.9).expect("subsequent review");
        assert!(follow_up.good.next.stability.is_finite());
        assert!(follow_up.good.interval_days >= 0.0);
    }

    #[test]
    fn invalid_elapsed_or_memory_is_not_silently_normalized() {
        assert!(preview(
            Some(Memory {
                stability: f32::NAN,
                difficulty: 2.0
            }),
            1,
            0.9
        )
        .is_err());
        assert!(preview(
            Some(Memory {
                stability: 1.0,
                difficulty: f32::INFINITY
            }),
            1,
            0.9
        )
        .is_err());
        assert!(preview(None, 0, 0.69).is_err());
    }

    #[test]
    fn invalid_state_rejected() {
        assert_eq!(
            preview(
                Some(Memory {
                    stability: -1.0,
                    difficulty: 3.0
                }),
                2,
                0.9
            ),
            Err(ScheduleError::InvalidState)
        );
    }
}
