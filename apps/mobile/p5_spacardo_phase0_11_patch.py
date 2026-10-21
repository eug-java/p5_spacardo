#!/usr/bin/env python3
"""Apply Phase 0.11 to a working P5 Spacardo apps/mobile checkout.

Does not open or modify the SQLite database. Creates timestamped source backups.
Designed to apply after add_deck_delete.py and the Linux FSRS factory fix.
"""
from pathlib import Path
from datetime import datetime
import shutil
import re
import sys

root = Path.cwd()
db = root / 'lib/data/local_database.dart'
ui = root / 'lib/main.dart'
if not db.is_file() or not ui.is_file():
    sys.exit('ERROR: Run this script from apps/mobile.')
a = db.read_text(encoding='utf8')
b = ui.read_text(encoding='utf8')
if 'Future<bool> deleteDeck(' not in a or 'Future<void> _deleteDeck(' not in b:
    sys.exit('ERROR: Apply the earlier deck-delete patch before Phase 0.11.')
if 'Future<bool> renameDeck(' in a or 'Future<void> _renameDeck(' in b:
    sys.exit('ERROR: Phase 0.11 already applied. No files changed.')

# All target anchors must exist before writing anything.
def replace_once(s, before, after, context):
    if s.count(before) != 1:
        raise RuntimeError(f'Cannot locate unique {context} anchor (count={s.count(before)}). No files changed.')
    return s.replace(before, after, 1)

# Deck CRUD. Insert into existing extension before deleteDeck.
anchor = '  /// Permanently deletes one deck and its cards in a single transaction.'
rename_method = '''  /// Renames a deck without changing its card associations.
  Future<bool> renameDeck(String deckId, String title) async {
    final normalized = title.trim();
    if (deckId.isEmpty || normalized.isEmpty || normalized.length > 120) {
      throw ArgumentError('Invalid deck title or ID');
    }
    return transaction(() async {
      final exists = await customSelect(
        'SELECT id FROM decks WHERE id = ?',
        variables: [Variable.withString(deckId)],
      ).getSingleOrNull();
      if (exists == null) return false;
      await customStatement(
        'UPDATE decks SET title = ? WHERE id = ?', [normalized, deckId]);
      return true;
    });
  }

'''
a = replace_once(a, anchor, rename_method + anchor, 'DeckCrud deleteDeck')

# Additional extension is appended rather than trying to change source methods.
a += """

/// Non-destructive management operations, preserving review history on edits.
class ManagedCardRecord {
  final String id;
  final String front;
  final String back;
  final int? dueAtMs;
  const ManagedCardRecord(this.id, this.front, this.back, this.dueAtMs);
}

class UndoCandidate {
  final String cardId;
  final String operationId;
  const UndoCandidate(this.cardId, this.operationId);
}

extension Phase011Management on LocalDatabase {
  /// Returns all cards, including cards not currently due for review.
  Future<List<ManagedCardRecord>> listManagedCards(String deckId) async {
    final rows = await customSelect('''
      SELECT c.id AS id, f.value_html AS front, b.value_html AS back,
        s.due_at_ms AS due_at_ms
      FROM cards c
      JOIN note_fields f ON f.note_id = c.note_id AND f.ordinal = 0
      JOIN note_fields b ON b.note_id = c.note_id AND b.ordinal = 1
      LEFT JOIN card_states s ON s.card_id = c.id
      WHERE c.deck_id = ?
      ORDER BY c.id
    ''', variables: [Variable.withString(deckId)]).get();
    return rows.map((row) => ManagedCardRecord(
      row.read<String>('id'), row.read<String>('front'),
      row.read<String>('back'), row.readNullable<int>('due_at_ms'),
    )).toList();
  }

  /// Edits Basic note fields. Shared notes are protected from cross-card edits.
  Future<bool> updateBasicCard(String cardId, String front, String back) async {
    final f = front.trim();
    final b = back.trim();
    if (cardId.isEmpty || f.isEmpty || b.isEmpty ||
        f.length > 50000 || b.length > 50000) {
      throw ArgumentError('Invalid card fields');
    }
    return transaction(() async {
      final row = await customSelect(
        'SELECT note_id FROM cards WHERE id = ?',
        variables: [Variable.withString(cardId)],
      ).getSingleOrNull();
      if (row == null) return false;
      final noteId = row.read<String>('note_id');
      final uses = await customSelect(
        'SELECT COUNT(*) AS n FROM cards WHERE note_id = ?',
        variables: [Variable.withString(noteId)],
      ).getSingle();
      if (uses.read<int>('n') != 1) {
        throw StateError('Editing shared notes is not supported yet');
      }
      await customStatement(
        'UPDATE note_fields SET value_html = ? WHERE note_id = ? AND ordinal = 0',
        [f, noteId]);
      await customStatement(
        'UPDATE note_fields SET value_html = ? WHERE note_id = ? AND ordinal = 1',
        [b, noteId]);
      return true;
    });
  }

  /// Deletes one card and its review history atomically, retaining shared notes.
  Future<bool> deleteBasicCard(String cardId) async {
    if (cardId.isEmpty) throw ArgumentError('Card ID cannot be empty');
    return transaction(() async {
      final row = await customSelect(
        'SELECT note_id FROM cards WHERE id = ?',
        variables: [Variable.withString(cardId)],
      ).getSingleOrNull();
      if (row == null) return false;
      final noteId = row.read<String>('note_id');
      await customStatement('DELETE FROM review_events WHERE card_id = ?', [cardId]);
      await customStatement('DELETE FROM card_states WHERE card_id = ?', [cardId]);
      await customStatement('DELETE FROM cards WHERE id = ?', [cardId]);
      final remaining = await customSelect(
        'SELECT 1 FROM cards WHERE note_id = ? LIMIT 1',
        variables: [Variable.withString(noteId)],
      ).getSingleOrNull();
      if (remaining == null) {
        await customStatement('DELETE FROM note_fields WHERE note_id = ?', [noteId]);
        await customStatement('DELETE FROM notes WHERE id = ?', [noteId]);
      }
      return true;
    });
  }

  /// Finds the most recent active review within a deck after app restart.
  Future<UndoCandidate?> latestUndoForDeck(String deckId) async {
    final row = await customSelect('''
      SELECT e.card_id AS card_id, e.operation_id AS operation_id
      FROM review_events e
      JOIN cards c ON c.id = e.card_id
      WHERE c.deck_id = ? AND e.undone = 0
      ORDER BY e.reviewed_at_ms DESC, e.rowid DESC LIMIT 1
    ''', variables: [Variable.withString(deckId)]).getSingleOrNull();
    if (row == null) return null;
    return UndoCandidate(row.read<String>('card_id'),
        row.read<String>('operation_id'));
  }
}
"""

home_start = b.index('class _HomePageState extends State<_HomePage> {')
practice_start = b.index('class _PracticePage extends StatefulWidget', home_start)
home = b[home_start:practice_start]

anchor = '  Future<void> _deleteDeck(DeckRecord deck) async {'
rename_ui = '''  Future<void> _renameDeck(DeckRecord deck) async {
    final controller = TextEditingController(text: deck.title);
    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rename deck'),
        content: TextField(controller: controller, autofocus: true,
          maxLength: 120, decoration: const InputDecoration(labelText: 'Deck name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Save')),
        ],
      ),
    );
    controller.dispose();
    if (title == null || title.isEmpty || title == deck.title || !mounted) return;
    try {
      await widget.database.renameDeck(deck.id, title);
      if (mounted) setState(() { _reload(); });
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not rename deck: $error')));
    }
  }

'''
home = replace_once(home, anchor, rename_ui + anchor, 'HomePage delete handler')
# Wrap old delete IconButton in a Row with edit button.
old = '''              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete deck',
                onPressed: () => _deleteDeck(deck),
              ),'''
new = '''              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Rename deck', onPressed: () => _renameDeck(deck)),
                IconButton(icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete deck', onPressed: () => _deleteDeck(deck)),
              ]),'''
# User ran dart format so likely same semantic formatting, use regex.
pat = re.compile(r"trailing:\s*IconButton\(\s*icon:\s*const Icon\(Icons\.delete_outline\),\s*tooltip:\s*'Delete deck',\s*onPressed:\s*\(\) => _deleteDeck\(deck\),\s*\),")
if len(pat.findall(home)) != 1: raise RuntimeError('Cannot locate delete icon, no files changed')
home = pat.sub(new.strip(), home, count=1)
b = b[:home_start] + home + b[practice_start:]

# Practice: request persistent Undo on deck changes. Use a separate async read, no setState returning Future.
needle = '  bool _ratingBusy = false;'
replacement = '''  bool _ratingBusy = false;
  Future<List<ManagedCardRecord>>? _allCards;
  int _undoLookupGeneration = 0;

  Future<void> _restoreUndo() async {
    final deckId = widget.deckId;
    final generation = ++_undoLookupGeneration;
    if (deckId == null) return;
    try {
      final candidate = await widget.database.latestUndoForDeck(deckId);
      if (!mounted || generation != _undoLookupGeneration || widget.deckId != deckId) return;
      setState(() {
        lastCardId = candidate?.cardId;
        lastOperationId = candidate?.operationId;
      });
    } catch (error) {
      debugPrint('Could not restore review undo: $error');
    }
  }

  void _reloadAllCards() {
    _allCards = widget.deckId == null ? null :
        widget.database.listManagedCards(widget.deckId!);
  }
'''
b = replace_once(b, needle, replacement, 'PracticeState _ratingBusy')
# Initial load hook and deck switching (match both formatted/unformatted forms).
b = replace_once(b, 'super.initState();\n    _reload();', 'super.initState();\n    _reload();', 'init state first occurrence') if False else b
# Find exact in PracticeState only
start = b.index('class _PracticePageState extends State<_PracticePage> {')
end = b.index('class _ImportPage extends StatelessWidget', start)
p = b[start:end]
p = re.sub(r'(void initState\(\)\s*\{\s*super\.initState\(\);\s*_reload\(\);)', r'\1 _reloadAllCards(); _restoreUndo();', p, count=1)
if '_reloadAllCards(); _restoreUndo();' not in p: raise RuntimeError('Cannot modify Practice init')
# replace didUpdateWidget body line with append prior method end before next method
needle = '  void _reload() {'
p = replace_once(p, needle, '''  // Reload Undo only when the selected deck changes.
  void _onDeckChanged() {
    lastCardId = null;
    lastOperationId = null;
    _reloadAllCards();
    _restoreUndo();
  }

''' + needle, 'Practice _reload')
# Locate conditional deck update and add call
match = re.search(r'if\s*\(oldWidget\.deckId != widget\.deckId\)\s*\{[^{}]*?_reload\(\);',p)
if match is None: raise RuntimeError('Cannot find deck update reset')
frag = match.group(0); p = p.replace(frag, frag + ' _onDeckChanged();', 1)
# Add handlers before _rate method
needle = '  /// Ratings are enabled only when the actual native FSRS library loads.'
handlers = '''  Future<void> _editCard(ManagedCardRecord card) async {
    final front = TextEditingController(text: card.front);
    final back = TextEditingController(text: card.back);
    final result = await showDialog<List<String>>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit card'),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: front, maxLength: 5000,
              decoration: const InputDecoration(labelText: 'Front')),
            TextField(controller: back, maxLength: 5000,
              decoration: const InputDecoration(labelText: 'Back')),
          ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext,
            [front.text, back.text]), child: const Text('Save')),
        ],
      ),
    );
    front.dispose(); back.dispose();
    if (result == null || !mounted) return;
    try {
      await widget.database.updateBasicCard(card.id, result[0], result[1]);
      if (mounted) setState(() { _reloadAllCards(); _reload(); });
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not edit card: $error')));
    }
  }

  Future<void> _deleteCard(ManagedCardRecord card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete card?'),
        content: const Text('Delete this card and its review history permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await widget.database.deleteBasicCard(card.id);
      if (mounted) {
        setState(() {
          if (lastCardId == card.id) { lastCardId = null; lastOperationId = null; }
          practiced.remove(card.id);
          _reloadAllCards(); _reload();
        });
      }
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete card: $error')));
    }
  }

  String _dueLabel(int? dueAtMs) {
    if (dueAtMs == null) return 'New / not scheduled';
    final due = DateTime.fromMillisecondsSinceEpoch(dueAtMs).toLocal();
    return 'Next review: ${due.toIso8601String().replaceFirst('T', ' ').split('.').first}';
  }

'''
p = replace_once(p, needle, handlers + needle, 'rate method')
# Update card create to refresh both lists
m = re.search(r'(await widget\.database\.addBasicCard\([^;]+;)(.*?)(\}\s*catch)', p, flags=re.S)
if m is None: raise RuntimeError('Card add target absent')
segment = m.group(0)
if 'setState' not in segment: raise RuntimeError('Card add state target absent')
segment_new = segment.replace('setState(() {', 'setState(() { _reloadAllCards();', 1)
p = p.replace(segment, segment_new, 1)
# Add All cards management panel below Create card in ListView
pat = re.compile(r'(FilledButton\.icon\(onPressed:\s*_addCard,.*?label:\s*Text\(l\.createCard\)\),)', re.S)
if len(pat.findall(p)) != 1: raise RuntimeError('Create card button target absent')
panel = '''
        const SizedBox(height: 12),
        ExpansionTile(title: const Text('Manage all cards'),
          subtitle: const Text('Edit, delete, or inspect the next review date'),
          children: [
            if (_allCards != null) FutureBuilder<List<ManagedCardRecord>>(
              future: _allCards,
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Text('Could not load cards');
                if (!snapshot.hasData) return const CircularProgressIndicator();
                if (snapshot.data!.isEmpty) return const Text('No cards in this deck');
                return Column(children: [
                  for (final item in snapshot.data!) ListTile(
                    title: Text(item.front, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(_dueLabel(item.dueAtMs)),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Edit card', onPressed: () => _editCard(item)),
                      IconButton(icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete card', onPressed: () => _deleteCard(item)),
                    ]),
                  ),
                ]);
              },
            ),
          ],
        ),'''
p = pat.sub(lambda m: m.group(1) + panel, p, count=1)
# When review succeeded refresh management list for due dates
needle = '          practiced.add(card.id);'
p = replace_once(p, needle, needle + '\n          _reloadAllCards();', 'review UI update')
# Undo refresh due display
needle = '      setState(() {'
# specifically after undoLastReview
u = p.index('Future<void> _undo()')
needle2 = '_reload();'
pos = p.index(needle2,u)
p = p[:pos] + '_reloadAllCards(); ' + p[pos:]
b = b[:start] + p + b[end:]

stamp = datetime.now().strftime('%Y%m%d_%H%M%S')
for path in (db,ui):
    shutil.copy2(path, path.with_name(path.name+'.bak_'+stamp))
db.write_text(a, encoding='utf8')
ui.write_text(b, encoding='utf8')
print('Phase 0.11 source patch applied. Backups: .bak_'+stamp)
print('Database NOT modified. Run dart format, flutter analyze and flutter test.')
