import 'package:drift/drift.dart' show Variable;
import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p5_spacardo/data/local_database.dart';
import 'package:p5_spacardo/scheduler/fsrs_api.dart';
import 'package:p5_spacardo/scheduler/study_review_service.dart';

/// Deterministic fixture checks the persistence contract, not FSRS mathematics.
class _FixtureEngine implements FsrsEngine {
  int calls = 0;
  @override
  FsrsChoices preview({
    required double? stability,
    required double? difficulty,
    required int elapsedDays,
    double retention = 0.90,
  }) {
    calls++;
    return const FsrsChoices(
      FsrsChoice(0.2, 0.2, 6.4),
      FsrsChoice(1.3, 1.3, 5.1),
      FsrsChoice(2.25, 2.25, 2.1),
      FsrsChoice(8.3, 8.3, 1.0),
    );
  }
}

Future<Map<String, dynamic>> _state(LocalDatabase db, String cardId) async {
  final row = await db.customSelect(
    'SELECT phase, due_at_ms, stability, difficulty FROM card_states WHERE card_id = ?',
    variables: [Variable.withString(cardId)],
  ).getSingle();
  return {
    'phase': row.read<String>('phase'),
    'due_at_ms': row.readNullable<int>('due_at_ms'),
    'stability': row.readNullable<double>('stability'),
    'difficulty': row.readNullable<double>('difficulty'),
  };
}

void main() {
  test('review is persisted across database close/open and undo restores state',
      () async {
    final temp = await Directory.systemTemp.createTemp('spacardo_fsrs_');
    final path = '${temp.path}/review.sqlite';
    final now = DateTime.utc(2026, 10, 21, 12);
    final reviewedAtMs = now.millisecondsSinceEpoch;
    late final String deckId;
    late final String cardId;
    late final Map<String, dynamic> before;
    try {
      final db = LocalDatabase.forTesting(NativeDatabase(File(path)));
      deckId = await db.addDeck('Integration');
      cardId = await db.addBasicCard(deckId, 'Front', 'Back');
      before = await _state(db, cardId);
      final engine = _FixtureEngine();
      final service = StudyReviewService(db, engine);
      expect(
          await service.answer(
              cardId: cardId, rating: 3, operationId: 'review-once', now: now),
          isTrue);
      expect(engine.calls, 1);
      expect(
          await service.answer(
              cardId: cardId, rating: 3, operationId: 'review-once', now: now),
          isFalse);
      final saved = await _state(db, cardId);
      expect(saved['stability'], closeTo(2.25, 0.0001));
      expect(saved['difficulty'], closeTo(2.1, 0.0001));
      expect(saved['due_at_ms'],
          reviewedAtMs + (2.25 * Duration.millisecondsPerDay).round());
      expect(saved['phase'], 'review');
      final events = await db
          .customSelect(
              'SELECT before_state_json, after_state_json FROM review_events')
          .get();
      expect(events, hasLength(1));
      expect(
          jsonDecode(events.single.read<String>('before_state_json')), before);
      expect(jsonDecode(events.single.read<String>('after_state_json')), saved);
      await db.close();

      final reopened = LocalDatabase.forTesting(NativeDatabase(File(path)));
      expect(await _state(reopened, cardId), saved);
      final candidate = await reopened.latestUndoForDeck(deckId);
      expect(candidate?.operationId, 'review-once');
      expect(await reopened.undoLastReview(cardId, 'review-once'), isTrue);
      expect(await _state(reopened, cardId), before);
      expect(await reopened.latestUndoForDeck(deckId), isNull);
      expect(await reopened.undoLastReview(cardId, 'review-once'), isFalse);
      final count = await reopened
          .customSelect(
              'SELECT COUNT(*) AS n FROM review_events WHERE undone = 1')
          .getSingle();
      expect(count.read<int>('n'), 1);
      await reopened.close();
    } finally {
      await temp.delete(recursive: true);
    }
  });

  test('stale concurrent result does not overwrite a completed review',
      () async {
    final db = LocalDatabase.forTesting(NativeDatabase.memory());
    try {
      final deckId = await db.addDeck('Concurrent');
      final cardId = await db.addBasicCard(deckId, 'Q', 'A');
      final old = await db.getStudySnapshot(cardId);
      const outcome = FsrsReviewOutcome(
          stability: 2.0, difficulty: 3.0, intervalDays: 2.0, phase: 'review');
      expect(
          await db.commitFsrsReview(
              cardId: cardId,
              operationId: 'op1',
              rating: 3,
              expectedReviewCount: old.reviewCount,
              outcome: outcome,
              reviewedAtMs: 1792584000000),
          isTrue);
      await expectLater(
          db.commitFsrsReview(
              cardId: cardId,
              operationId: 'op2',
              rating: 3,
              expectedReviewCount: old.reviewCount,
              outcome: outcome,
              reviewedAtMs: 1792584000001),
          throwsStateError);
      final rows = await db
          .customSelect('SELECT COUNT(*) AS n FROM review_events')
          .getSingle();
      expect(rows.read<int>('n'), 1);
    } finally {
      await db.close();
    }
  });
}
