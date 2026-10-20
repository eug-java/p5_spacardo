import '../data/local_database.dart';
import 'fsrs_api.dart';

/// Coordinates a native FSRS preview with a transactional persistence write.
/// Never uses fixed or fabricated fallback intervals.
class StudyReviewService {
  const StudyReviewService(this.database, this.engine);
  final LocalDatabase database;
  final FsrsEngine engine;

  Future<bool> answer({
    required String cardId,
    required int rating,
    required String operationId,
    required DateTime now,
  }) async {
    if (rating < 1 || rating > 4) throw ArgumentError.value(rating, 'rating');
    final snapshot = await database.getStudySnapshot(cardId);
    if ((snapshot.stability == null) != (snapshot.difficulty == null)) {
      throw StateError('Incomplete persisted FSRS memory');
    }
    if (operationId.trim().isEmpty) {
      throw ArgumentError.value(operationId, 'operationId');
    }
    final timestamp = now.toUtc().millisecondsSinceEpoch;
    final last = snapshot.lastReviewedAtMs;
    if (last != null && timestamp < last) {
      throw StateError('Clock precedes the last review');
    }
    final elapsed = last == null ? 0 :
        (timestamp - last) ~/ Duration.millisecondsPerDay;
    final choices = engine.preview(
      stability: snapshot.stability,
      difficulty: snapshot.difficulty,
      elapsedDays: elapsed,
    );
    final choice = choices.forRating(rating);
    // This first integration uses FSRS interval scheduling. Full intra-day
    // learning and relearning steps are NOT implemented yet.
    final phase = rating == 1 ? 'relearning' : 'review';
    return database.commitFsrsReview(
      cardId: cardId,
      operationId: operationId,
      rating: rating,
      expectedReviewCount: snapshot.reviewCount,
      outcome: FsrsReviewOutcome(
        stability: choice.stability,
        difficulty: choice.difficulty,
        intervalDays: choice.intervalDays,
        phase: phase,
      ),
      reviewedAtMs: timestamp,
    );
  }
}
