import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p5_spacardo/data/local_database.dart';
import 'package:p5_spacardo/scheduler/native_fsrs.dart';
import 'package:p5_spacardo/scheduler/study_review_service.dart';

Future<Map<String, dynamic>> readState(LocalDatabase db, String cardId) async {
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
  final libraryPath = Platform.environment['SPACARDO_FSRS_LIBRARY'];
  final configured =
      Platform.isLinux && libraryPath != null && libraryPath.isNotEmpty;

  test('native Rust FSRS persists through SQLite reopen and Undo', () async {
    final library = DynamicLibrary.open(libraryPath!);
    final engine = NativeFsrsEngine(library);
    final good = engine
        .preview(
          stability: null,
          difficulty: null,
          elapsedDays: 0,
        )
        .forRating(3);
    final temp = await Directory.systemTemp.createTemp('p5_fsrs_e2e_');
    final file = File('${temp.path}/cards.sqlite');
    final now = DateTime.utc(2026, 10, 21, 12);
    final nowMs = now.millisecondsSinceEpoch;
    const operationId = 'native-fsrs-e2e-001';
    LocalDatabase? database;
    try {
      database = LocalDatabase.forTesting(NativeDatabase(file));
      final deckId = await database.addDeck('Native E2E');
      final cardId = await database.addBasicCard(deckId, 'Q', 'A');
      final before = await readState(database, cardId);
      expect(
          await StudyReviewService(database, engine).answer(
            cardId: cardId,
            rating: 3,
            operationId: operationId,
            now: now,
          ),
          isTrue);
      final saved = await readState(database, cardId);
      expect(saved['phase'], 'review');
      expect(saved['stability'], closeTo(good.stability, 0.00001));
      expect(saved['difficulty'], closeTo(good.difficulty, 0.00001));
      expect(saved['due_at_ms'],
          nowMs + (good.intervalDays * Duration.millisecondsPerDay).round());

      // Reusing the same operation must not add another review.
      expect(
          await StudyReviewService(database, engine).answer(
            cardId: cardId,
            rating: 3,
            operationId: operationId,
            now: now,
          ),
          isFalse);
      final events = await database.customSelect(
        'SELECT before_state_json, after_state_json FROM review_events '
        'WHERE operation_id = ?',
        variables: [Variable.withString(operationId)],
      ).get();
      expect(events, hasLength(1));
      expect(
          jsonDecode(events.single.read<String>('before_state_json')), before);
      expect(jsonDecode(events.single.read<String>('after_state_json')), saved);
      await database.close();
      database = null;

      database = LocalDatabase.forTesting(NativeDatabase(file));
      expect(await readState(database, cardId), saved);
      final lastReview = await database.latestUndoForDeck(deckId);
      expect(lastReview?.operationId, operationId);
      expect(await database.undoLastReview(cardId, operationId), isTrue);
      expect(await readState(database, cardId), before);
      expect(await database.latestUndoForDeck(deckId), isNull);
      expect(await database.undoLastReview(cardId, operationId), isFalse);
      final undone = await database.customSelect(
        'SELECT undone FROM review_events WHERE operation_id = ?',
        variables: [Variable.withString(operationId)],
      ).getSingle();
      expect(undone.read<int>('undone'), 1);
      await database.close();
      database = null;

      // Confirm Undo is durable as well.
      database = LocalDatabase.forTesting(NativeDatabase(file));
      expect(await readState(database, cardId), before);
      expect(await database.latestUndoForDeck(deckId), isNull);
    } finally {
      await database?.close();
      await temp.delete(recursive: true);
    }
  }, skip: configured ? false : 'Linux Rust library not configured');
}
