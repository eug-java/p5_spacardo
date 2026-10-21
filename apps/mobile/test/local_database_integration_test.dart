import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p5_spacardo/data/local_database.dart';

void main() {
  late LocalDatabase database;

  setUp(() {
    database = LocalDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('deck rename preserves its cards', () async {
    final deckId = await database.addDeck('Before');
    final cardId = await database.addBasicCard(deckId, 'Question', 'Answer');
    expect(await database.renameDeck(deckId, 'After'), isTrue);
    final decks = await database.listDecks();
    expect(decks.single.title, 'After');
    final cards = await database.listManagedCards(deckId);
    expect(cards.single.id, cardId);
    expect(cards.single.front, 'Question');
  });

  test('edit basic card changes fields without changing identity', () async {
    final deckId = await database.addDeck('Test');
    final cardId = await database.addBasicCard(deckId, 'Old front', 'Old back');
    expect(await database.updateBasicCard(cardId, 'New front', 'New back'),
        isTrue);
    final card = (await database.listManagedCards(deckId)).single;
    expect(card.id, cardId);
    expect(card.front, 'New front');
    expect(card.back, 'New back');
  });

  test('deleting a card cleans up its note and state', () async {
    final deckId = await database.addDeck('Test');
    final cardId = await database.addBasicCard(deckId, 'Front', 'Back');
    expect(await database.deleteBasicCard(cardId), isTrue);
    expect(await database.deleteBasicCard(cardId), isFalse);
    expect(await database.listManagedCards(deckId), isEmpty);
    for (final table in ['cards', 'card_states', 'notes', 'note_fields']) {
      final rows =
          await database.customSelect('SELECT COUNT(*) AS n FROM $table').get();
      expect(rows.single.read<int>('n'), 0, reason: table);
    }
  });

  test('deleting one deck leaves the other deck intact', () async {
    final first = await database.addDeck('First');
    final second = await database.addDeck('Second');
    await database.addBasicCard(first, 'One', '1');
    await database.addBasicCard(second, 'Two', '2');
    expect(await database.deleteDeck(first), isTrue);
    expect((await database.listDecks()).single.id, second);
    expect((await database.listManagedCards(second)).single.front, 'Two');
  });

  test('undo lookup sees the latest non-undone event', () async {
    final deckId = await database.addDeck('Test');
    final cardId = await database.addBasicCard(deckId, 'Front', 'Back');
    final empty = await database.latestUndoForDeck(deckId);
    expect(empty, isNull);
    await database.customStatement('''
      INSERT INTO review_events
      (id, operation_id, card_id, reviewed_at_ms, rating,
       before_state_json, after_state_json, undone)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', ['event-1', 'op-1', cardId, 1000, 3, '{}', '{}', 0]);
    final result = await database.latestUndoForDeck(deckId);
    expect(result?.cardId, cardId);
    expect(result?.operationId, 'op-1');
    await database.customStatement(
        'UPDATE review_events SET undone = 1 WHERE operation_id = ?', ['op-1']);
    expect(await database.latestUndoForDeck(deckId), isNull);
  });
}
