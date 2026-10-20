// Phase 0.5: persistent storage and a validated FSRS result persistence contract.
import 'dart:math';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'sql_schema.dart';

class LocalDatabase extends GeneratedDatabase {
  LocalDatabase()
      : super(driftDatabase(
          name: 'p5_spacardo_phase0',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ));

  @override
  int get schemaVersion => 2;

  @override
  Iterable<TableInfo<Table, dynamic>> get allTables => const [];

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          for (final ddl in schemaV1) {
            await customStatement(ddl);
          }
          await ensureBasicType();
        },
        onUpgrade: (migrator, from, to) async {
          if (from < 2) await ensureBasicType();
        },
      );
}


class DeckRecord {
  final String id;
  final String title;
  final int createdAtMs;
  const DeckRecord(this.id, this.title, this.createdAtMs);
}

extension DeckCrud on LocalDatabase {
  Future<List<DeckRecord>> listDecks() async {
    final rows = await customSelect(
      'SELECT id, title, created_at_ms FROM decks ORDER BY title COLLATE NOCASE',
    ).get();
    return rows.map((row) => DeckRecord(
      row.read<String>('id'),
      row.read<String>('title'),
      row.read<int>('created_at_ms'),
    )).toList();
  }

  Future<String> addDeck(String title) async {
    final normalized = title.trim();
    if (normalized.isEmpty || normalized.length > 120) {
      throw ArgumentError('Deck title must have 1-120 characters');
    }
    final now = DateTime.now().microsecondsSinceEpoch;
    // Per-install random values prevent collisions in this local-only MVP.
    // A cryptographically strong UUID service is required before sync support.
    final id = '${now.toRadixString(16)}_${_deckRandomSuffix()}';
    await customStatement(
      'INSERT INTO decks (id, parent_id, title, created_at_ms) VALUES (?, NULL, ?, ?)',
      [id, normalized, DateTime.now().millisecondsSinceEpoch],
    );
    return id;
  }
}

String _deckRandomSuffix() => Random.secure().nextInt(0x7fffffff).toRadixString(36);


/// Basic note/card support; scheduling is provisional until Rust FSRS FFI is integrated.
class BasicCardRecord {
  final String id;
  final String deckId;
  final String front;
  final String back;
  final int? dueAtMs;
  const BasicCardRecord(this.id, this.deckId, this.front, this.back, this.dueAtMs);
}

String _newId() => '${DateTime.now().microsecondsSinceEpoch.toRadixString(16)}_${_deckRandomSuffix()}';

extension BasicCardCrud on LocalDatabase {
  Future<void> ensureBasicType() async {
    await customStatement('INSERT OR IGNORE INTO note_types (id, name, css) VALUES (?, ?, ?)',
        ['basic', 'Basic', '']);
  }

  Future<String> addBasicCard(String deckId, String front, String back) async {
    if (front.trim().isEmpty || back.trim().isEmpty) {
      throw ArgumentError('Both card fields are required');
    }
    if (front.length > 50000 || back.length > 50000) {
      throw ArgumentError('Card field exceeds 50000 characters');
    }
    final noteId = _newId();
    final cardId = _newId();
    await transaction(() async {
      await ensureBasicType();
      await customStatement('INSERT INTO notes (id, note_type_id, created_at_ms) VALUES (?, ?, ?)',
          [noteId, 'basic', DateTime.now().millisecondsSinceEpoch]);
      await customStatement('INSERT INTO note_fields (note_id, ordinal, value_html) VALUES (?, ?, ?)',
          [noteId, 0, front.trim()]);
      await customStatement('INSERT INTO note_fields (note_id, ordinal, value_html) VALUES (?, ?, ?)',
          [noteId, 1, back.trim()]);
      await customStatement('INSERT INTO cards (id, note_id, deck_id, template_ordinal) VALUES (?, ?, ?, ?)',
          [cardId, noteId, deckId, 0]);
      await customStatement('INSERT INTO card_states (card_id, phase) VALUES (?, ?)',
          [cardId, 'new']);
    });
    return cardId;
  }

  Future<List<BasicCardRecord>> listBasicCards(String deckId) async {
    final rows = await customSelect('''
      SELECT c.id AS id, c.deck_id AS deck_id,
        f.value_html AS front, b.value_html AS back, s.due_at_ms AS due_at_ms
      FROM cards c
      JOIN note_fields f ON f.note_id = c.note_id AND f.ordinal = 0
      JOIN note_fields b ON b.note_id = c.note_id AND b.ordinal = 1
      LEFT JOIN card_states s ON s.card_id = c.id
      WHERE c.deck_id = ? AND c.suspended = 0
        AND (s.due_at_ms IS NULL OR s.due_at_ms <= ?)
      ORDER BY COALESCE(s.due_at_ms, 0), c.id
    ''', variables: [Variable.withString(deckId), Variable.withInt(DateTime.now().millisecondsSinceEpoch)]).get();
    return rows.map((r) => BasicCardRecord(
      r.read<String>('id'), r.read<String>('deck_id'),
      r.read<String>('front'), r.read<String>('back'),
      r.readNullable<int>('due_at_ms'),
    )).toList();
  }

  /// Legacy provisional scheduling was deliberately removed in Phase 0.6.
  /// Production submissions must use commitFsrsReview with an outcome
  /// computed by the Rust FSRS adapter. Never silently substitute intervals.
  @Deprecated('Use commitFsrsReview with a validated Rust FSRS outcome')
  Future<bool> recordPractice(String cardId, int rating, String operationId) {
    throw UnsupportedError('FSRS bridge is not yet initialized. Rating disabled.');
  }

  /// Only the latest non-undone review of this card may be reverted.
  Future<bool> undoLastReview(String cardId, String operationId) async {
    return transaction(() async {
      final latest = await customSelect('''
        SELECT operation_id, before_state_json FROM review_events
        WHERE card_id = ? AND undone = 0
        ORDER BY reviewed_at_ms DESC, rowid DESC LIMIT 1
      ''', variables: [Variable.withString(cardId)]).getSingleOrNull();
      if (latest == null || latest.read<String>('operation_id') != operationId) return false;
      final state = jsonDecode(latest.read<String>('before_state_json')) as Map<String, dynamic>;
      await customStatement('''
        UPDATE card_states SET phase=?, due_at_ms=?, stability=?, difficulty=? WHERE card_id=?
      ''', [state['phase'], state['due_at_ms'], state['stability'], state['difficulty'], cardId]);
      await customStatement('UPDATE review_events SET undone=1 WHERE operation_id=?', [operationId]);
      return true;
    });
  }
}


/// Result of the Rust FSRS scheduling engine. This is not a scheduling
/// implementation: callers MUST obtain these values from the FSRS core.
class FsrsReviewOutcome {
  final double stability;
  final double difficulty;
  final double intervalDays;
  final String phase;

  const FsrsReviewOutcome({
    required this.stability,
    required this.difficulty,
    required this.intervalDays,
    required this.phase,
  });

  void validate() {
    if (!stability.isFinite || stability <= 0 ||
        !difficulty.isFinite || difficulty <= 0 || difficulty > 10 ||
        !intervalDays.isFinite || intervalDays < 0 || intervalDays > 36500 ||
        !const ['learning', 'review', 'relearning'].contains(phase)) {
      throw ArgumentError('Invalid FSRS review outcome');
    }
  }
}

extension FsrsReviewPersistence on LocalDatabase {
  /// Stores a Rust-produced review and its event atomically. The caller must
  /// compute the result from the current card state. Guard against stale
  /// inputs with expectedReviewCount (optimistic concurrency control).
  Future<bool> commitFsrsReview({
    required String cardId,
    required String operationId,
    required int rating,
    required int expectedReviewCount,
    required FsrsReviewOutcome outcome,
    required int reviewedAtMs,
  }) async {
    if (rating < 1 || rating > 4 || operationId.isEmpty || expectedReviewCount < 0) {
      throw ArgumentError('Invalid review request');
    }
    outcome.validate();
    final dueMs = reviewedAtMs + (outcome.intervalDays * Duration.millisecondsPerDay).round();
    return transaction(() async {
      final prior = await customSelect(
        'SELECT card_id, rating, undone FROM review_events WHERE operation_id = ?',
        variables: [Variable.withString(operationId)],
      ).getSingleOrNull();
      if (prior != null) {
        if (prior.read<String>('card_id') != cardId || prior.read<int>('rating') != rating) {
          throw StateError('Operation ID collision');
        }
        if (prior.read<int>('undone') != 0) {
          throw StateError('An undone operation ID cannot be reused');
        }
        return false;
      }
      final count = await customSelect(
        'SELECT COUNT(*) AS n FROM review_events WHERE card_id = ? AND undone = 0',
        variables: [Variable.withString(cardId)],
      ).getSingle();
      if (count.read<int>('n') != expectedReviewCount) {
        throw StateError('Stale review result; recompute FSRS');
      }
      final state = await customSelect(
        'SELECT phase, due_at_ms, stability, difficulty FROM card_states WHERE card_id = ?',
        variables: [Variable.withString(cardId)],
      ).getSingle();
      final latest = await customSelect('''
        SELECT MAX(reviewed_at_ms) AS t FROM review_events
        WHERE card_id = ? AND undone = 0
      ''', variables: [Variable.withString(cardId)]).getSingle();
      final latestAt = latest.readNullable<int>('t');
      if (latestAt != null && reviewedAtMs < latestAt) {
        throw StateError('Review time is older than active history');
      }
      final before = <String, dynamic>{
        'phase': state.read<String>('phase'),
        'due_at_ms': state.readNullable<int>('due_at_ms'),
        'stability': state.readNullable<double>('stability'),
        'difficulty': state.readNullable<double>('difficulty'),
      };
      final after = <String, dynamic>{
        'phase': outcome.phase,
        'due_at_ms': dueMs,
        'stability': outcome.stability,
        'difficulty': outcome.difficulty,
      };
      await customStatement('''
        UPDATE card_states SET phase=?, due_at_ms=?, stability=?, difficulty=? WHERE card_id=?
      ''', [outcome.phase, dueMs, outcome.stability, outcome.difficulty, cardId]);
      await customStatement('''
        INSERT INTO review_events
          (id, operation_id, card_id, reviewed_at_ms, rating, before_state_json, after_state_json)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      ''', [
        _newId(), operationId, cardId, reviewedAtMs, rating, jsonEncode(before), jsonEncode(after)
      ]);
      return true;
    });
  }
}

/// Snapshot used to prevent a preview calculated from stale persisted memory.
class StudySnapshot {
  final String phase;
  final double? stability;
  final double? difficulty;
  final int? lastReviewedAtMs;
  final int reviewCount;
  const StudySnapshot(this.phase, this.stability, this.difficulty,
      this.lastReviewedAtMs, this.reviewCount);
}

extension StudySnapshotQueries on LocalDatabase {
  Future<StudySnapshot> getStudySnapshot(String cardId) async {
    final state = await customSelect('''
      SELECT s.phase AS phase, s.stability AS stability,
        s.difficulty AS difficulty,
        (SELECT MAX(reviewed_at_ms) FROM review_events
          WHERE card_id = s.card_id AND undone = 0) AS last_reviewed,
        (SELECT COUNT(*) FROM review_events
          WHERE card_id = s.card_id AND undone = 0) AS review_count
      FROM card_states s WHERE s.card_id = ?
    ''', variables: [Variable.withString(cardId)]).getSingle();
    return StudySnapshot(
      state.read<String>('phase'),
      state.readNullable<double>('stability'),
      state.readNullable<double>('difficulty'),
      state.readNullable<int>('last_reviewed'),
      state.read<int>('review_count'),
    );
  }
}
