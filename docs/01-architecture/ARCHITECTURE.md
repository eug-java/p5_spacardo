# Architecture

Version: 0.2. Status: PROPOSED.

```text
 Android app                iOS app                 Web/PWA
      \                       |                      /
                     Flutter UI
                Router and Riverpod
                         |
               Application use cases
                         |
                 Domain ports/models
                     /         \
        Storage repository    Rust bridge
           Drift/SQLite       /       \
            /      \        FSRS       Anki codec
        Native DB  WASM DB   Native/WASM  Native/WASM
          Files   OPFS/IndexedDB
```

## Ownership boundaries
- UI calls application use cases and never executes SQL directly.
- Dart/Drift is the single writer of the active application database. Rust accepts versioned DTOs but does not mutate the active DB.
- Rust modules provide scheduling and package parsing/encoding; mobile targets link native binaries, Web uses WebAssembly.
- The Web implementation cannot assume operating-system file descriptors, threads, or SQLite native linking.
- Cards reference media by logical names and hashes, never absolute device paths.

## Study transaction
1. `StudyService` selects a due card and renders its question in a restricted view.
2. User reveals the answer and submits rating Again(1), Hard(2), Good(3), or Easy(4).
3. Use case supplies `review_operation_uuid`, time in UTC, and current scheduler preset to `SchedulerPort`.
4. Rust FSRS returns the new state and next due date.
5. In one Drift transaction store the card state, review event, and operation ID.
6. Repeating an operation ID must return the previous result without duplicating a review.
7. Undo restores prior card state while recording the cancellation in the audit trail.

## Package import pipeline
`file picker -> bounded archive reader -> inspect -> validate -> preview -> stage -> atomic commit -> report`.
For full collection restoration, a verifiable backup and complete validation precede replacement. Temporary media must be validated and relocated only on successful commit.

## FSRS
Scheduler input: `review_at_utc`, parameters and algorithm version, desired retention, memory state and learning/relearning steps. Preserve imported due dates by default; rescheduling after import requires explicit user action and prior backup.

## Web constraints
- PWA Cache Storage is for application assets, not the user collection.
- SQLite WASM uses supported OPFS/IndexedDB paths; persistence requests do not guarantee immunity to eviction.
- Use single-writer coordination for multiple tabs and migrations.
- Prevent imported HTML/JS from acquiring privileged application APIs.
- Process large archives in worker contexts with memory limits.

## Contracts (illustrative, not compiled)
```dart
abstract interface class PackageCompatibilityPort {
  Future<PackageInspection> inspect(InputFile file);
  Future<ImportResult> importDeck(InputFile file, ImportOptions options);
  Future<RestoreResult> restoreCollection(InputFile file);
  Future<OutputFile> exportDeck(DeckId deckId, ExportOptions options);
  Future<OutputFile> exportCollection(ExportOptions options);
}

abstract interface class SchedulerPort {
  Future<ReviewResult> applyRating(
    CardMemoryState state,
    ReviewRating rating,
    DateTime reviewedAtUtc,
    SchedulerPreset preset,
  );
}
```

All contract types and bindings will be validated and versioned after Phase 0.
