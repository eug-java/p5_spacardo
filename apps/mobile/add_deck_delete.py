#!/usr/bin/env python3
"""Apply the deck-delete feature to an existing P5 Spacardo checkout.

Run from apps/mobile. Creates backups and fails closed if the expected
source layout is missing. No database files are modified by this script.
"""
from pathlib import Path
from datetime import datetime
import shutil

root = Path.cwd()
source = root / 'lib/data/local_database.dart'
ui = root / 'lib/main.dart'
if not source.is_file() or not ui.is_file():
    raise SystemExit('Run from apps/mobile (lib/main.dart and lib/data/local_database.dart required).')

storage = source.read_text(encoding='utf-8')
app = ui.read_text(encoding='utf-8')

storage_anchor = '\n}\n\nString _deckRandomSuffix()'
assert storage.count(storage_anchor) == 1, 'Cannot find end of DeckCrud extension'
assert 'Future<bool> deleteDeck(' not in storage, 'deleteDeck already exists; no changes applied'

method = """

  /// Permanently deletes one deck and its cards in a single transaction.
  /// Child decks are protected. Shared notes are preserved until unused.
  Future<bool> deleteDeck(String deckId) async {
    if (deckId.isEmpty) throw ArgumentError('Deck ID cannot be empty');
    return transaction(() async {
      final target = await customSelect(
        'SELECT id FROM decks WHERE id = ?',
        variables: [Variable.withString(deckId)],
      ).getSingleOrNull();
      if (target == null) return false;

      final children = await customSelect(
        'SELECT 1 FROM decks WHERE parent_id = ? LIMIT 1',
        variables: [Variable.withString(deckId)],
      ).getSingleOrNull();
      if (children != null) {
        throw StateError('Move or delete child decks first');
      }

      // Preserve note IDs before deleting their cards. A note may be used
      // by other decks, so only delete it if no cards reference it anymore.
      final notes = await customSelect(
        'SELECT DISTINCT note_id FROM cards WHERE deck_id = ?',
        variables: [Variable.withString(deckId)],
      ).get();

      // Remove dependent records explicitly, even if foreign-key
      // enforcement was not enabled by an older database connection.
      await customStatement(''' 
        DELETE FROM review_events
        WHERE card_id IN (SELECT id FROM cards WHERE deck_id = ?)
      ''', [deckId]);
      await customStatement(''' 
        DELETE FROM card_states
        WHERE card_id IN (SELECT id FROM cards WHERE deck_id = ?)
      ''', [deckId]);
      await customStatement('DELETE FROM cards WHERE deck_id = ?', [deckId]);
      for (final row in notes) {
        final noteId = row.read<String>('note_id');
        await customStatement('''
          DELETE FROM note_fields
          WHERE note_id = ? AND NOT EXISTS (
            SELECT 1 FROM cards WHERE note_id = ?
          )
        ''', [noteId, noteId]);
        await customStatement('''
          DELETE FROM notes
          WHERE id = ? AND NOT EXISTS (
            SELECT 1 FROM cards WHERE note_id = ?
          )
        ''', [noteId, noteId]);
      }
      await customStatement('DELETE FROM decks WHERE id = ?', [deckId]);
      return true;
    });
  }
"""
storage = storage.replace(storage_anchor, method + storage_anchor, 1)

class_marker = 'class _HomePageState extends State<_HomePage> {'
assert app.count(class_marker) == 1, 'Cannot find _HomePageState'
start = app.index(class_marker)
end = app.index('\nclass _PracticePage', start)
home = app[start:end]
assert 'Future<void> _deleteDeck(' not in home, 'Delete UI already exists; no changes applied'
insert_before = '  @override\n  Widget build(BuildContext context) {'
assert home.count(insert_before) == 1, 'Cannot find HomePage build method'

delete_handler = '''  Future<void> _deleteDeck(DeckRecord deck) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete deck?'),
        content: Text(
          'Delete "${deck.title}" and all its cards and review history? '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      final deleted = await widget.database.deleteDeck(deck.id);
      if (!mounted) return;
      setState(() {
        _reload();
      });
      if (!deleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Deck no longer exists.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete deck: $error')),
      );
    }
  }

'''
home = home.replace(insert_before, delete_handler + insert_before, 1)
needle = '              onTap: () => widget.onDeckSelected(deck.id),'
assert home.count(needle) == 1, 'Cannot locate deck ListTile'
home = home.replace(needle, needle + '''
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete deck',
                onPressed: () => _deleteDeck(deck),
              ),''', 1)
app = app[:start] + home + app[end:]

stamp = datetime.now().strftime('%Y%m%d_%H%M%S')
for p in (source, ui):
    shutil.copy2(p, p.with_name(p.name + '.bak_' + stamp))
source.write_text(storage, encoding='utf-8')
ui.write_text(app, encoding='utf-8')
print('Patched:', source, ui, '\nBackups use suffix .bak_' + stamp)
