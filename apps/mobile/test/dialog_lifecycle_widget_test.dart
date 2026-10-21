import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p5_spacardo/data/local_database.dart';
import 'package:p5_spacardo/main.dart';

void main() {
  late LocalDatabase database;

  setUp(() {
    database = LocalDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  Future<void> boot(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1100, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(SpacardoTestHarness(database: database));
    await tester.pumpAndSettle();
  }

  Future<void> saveDialog(WidgetTester tester) async {
    await tester.tap(find.descendant(
      of: find.byType(AlertDialog),
      matching: find.widgetWithText(FilledButton, 'Save'),
    ));
    await tester.pumpAndSettle();
    // Give SQLite write and FutureBuilder a chance to complete.
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  testWidgets(
      'create, rename, cancel and delete deck without disposed controllers',
      (tester) async {
    await boot(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Create deck'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Deck A');
    await saveDialog(tester);
    expect((await database.listDecks()).single.title, 'Deck A');

    await tester.tap(find.byTooltip('Rename deck'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Deck B');
    await saveDialog(tester);
    expect((await database.listDecks()).single.title, 'Deck B');

    await tester.tap(find.byTooltip('Rename deck'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Not saved');
    await tester.tap(find.descendant(
      of: find.byType(AlertDialog),
      matching: find.widgetWithText(TextButton, 'Cancel'),
    ));
    await tester.pumpAndSettle();
    expect((await database.listDecks()).single.title, 'Deck B');
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Delete deck'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(await database.listDecks(), hasLength(1));

    await tester.tap(find.byTooltip('Delete deck'));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
      of: find.byType(AlertDialog),
      matching: find.widgetWithText(FilledButton, 'Delete'),
    ));
    await tester.pumpAndSettle();
    expect(await database.listDecks(), isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('create, edit and delete card with route-owned controllers',
      (tester) async {
    final id = await database.addDeck('Deck for cards');
    await boot(tester);
    await tester.tap(find.text('Deck for cards'));
    await tester.pumpAndSettle();

    await tester.tap(find.ancestor(
        of: find.byIcon(Icons.add), matching: find.byType(FilledButton)));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNWidgets(2));
    await tester.enterText(find.byType(TextField).at(0), 'Original question');
    await tester.enterText(find.byType(TextField).at(1), 'Original answer');
    await saveDialog(tester);
    expect((await database.listManagedCards(id)).single.front,
        'Original question');

    await tester.tap(find.text('Manage all cards'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit card'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Updated question');
    await tester.enterText(find.byType(TextField).at(1), 'Updated answer');
    await saveDialog(tester);
    final updated = (await database.listManagedCards(id)).single;
    expect(updated.front, 'Updated question');
    expect(updated.back, 'Updated answer');

    await tester.tap(find.byTooltip('Delete card'));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
      of: find.byType(AlertDialog),
      matching: find.widgetWithText(FilledButton, 'Delete'),
    ));
    await tester.pumpAndSettle();
    expect(await database.listManagedCards(id), isEmpty);
    expect(tester.takeException(), isNull);
  });
}
