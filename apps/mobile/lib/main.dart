import 'scheduler/scheduler_factory.dart';
import 'scheduler/study_review_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/local_database.dart';
import 'l10n/app_localizations.dart';

void main() => runApp(const P5SpacardoApp());

/// Phase 0.2 shell. Language preference is persisted across launches.
class P5SpacardoApp extends StatefulWidget {
  const P5SpacardoApp({super.key});

  @override
  State<P5SpacardoApp> createState() => _P5SpacardoAppState();
}

class _P5SpacardoAppState extends State<P5SpacardoApp> {
  Locale? _locale;
  final LocalDatabase _database = LocalDatabase();
  bool _loadingPreferences = true;

  @override
  void initState() {
    super.initState();
    _restoreLocale();
  }

  Future<void> _restoreLocale() async {
    try {
      final preferences = SharedPreferencesAsync();
      final tag = await preferences.getString('preferred_locale');
      Locale? selected;
      for (final candidate in AppLocalizations.supportedLocales) {
        if (candidate.toLanguageTag() == tag) selected = candidate;
      }
      if (mounted) {
        setState(() {
          _locale = selected;
          _loadingPreferences = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingPreferences = false);
    }
  }

  Future<void> _changeLocale(Locale? locale) async {
    setState(() => _locale = locale);
    try {
      final preferences = SharedPreferencesAsync();
      if (locale == null) {
        await preferences.remove('preferred_locale');
      } else {
        await preferences.setString('preferred_locale', locale.toLanguageTag());
      }
    } catch (error) {
      debugPrint('Could not persist locale selection: $error');
    }
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'P5 Spacardo',
        locale: _locale,
        localeResolutionCallback: (requested, supported) {
          if (_locale != null) return _locale;
          if (requested == null) return const Locale('en');
          for (final value in supported) {
            if (value.languageCode == requested.languageCode &&
                value.countryCode == requested.countryCode &&
                value.scriptCode == requested.scriptCode) {
              return value;
            }
          }
          for (final value in supported) {
            if (value.languageCode == requested.languageCode) return value;
          }
          return const Locale('en');
        },
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xff246f88))),
        darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xff246f88),
                brightness: Brightness.dark)),
        home: _loadingPreferences
            ? const Scaffold(body: Center(child: CircularProgressIndicator()))
            : _Shell(
                database: _database,
                locale: _locale,
                onLocaleChanged: _changeLocale),
      );
}

class _Shell extends StatefulWidget {
  const _Shell(
      {required this.database,
      required this.locale,
      required this.onLocaleChanged});
  final LocalDatabase database;
  final Locale? locale;
  final ValueChanged<Locale?> onLocaleChanged;

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  int selected = 0;
  String? activeDeckId;
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final wide = MediaQuery.sizeOf(context).width >= 720;
    final labels = [l.overview, l.cards, l.importAction, l.settings];
    final icons = [
      Icons.dashboard_outlined,
      Icons.school_outlined,
      Icons.file_open_outlined,
      Icons.settings_outlined
    ];
    final pages = [
      _HomePage(
          database: widget.database,
          onDeckSelected: (id) => setState(() {
                activeDeckId = id;
                selected = 1;
              })),
      _PracticePage(database: widget.database, deckId: activeDeckId),
      const _ImportPage(),
      _SettingsPage(
          locale: widget.locale, onLocaleChanged: widget.onLocaleChanged),
    ];
    void navigate(int v) => setState(() {
          selected = v;
          showAnswer = false;
        });
    return Scaffold(
      appBar: AppBar(title: Text('P5 Spacardo · ${labels[selected]}')),
      body: Row(children: [
        if (wide)
          NavigationRail(
            selectedIndex: selected,
            onDestinationSelected: navigate,
            labelType: NavigationRailLabelType.all,
            destinations: [
              for (var i = 0; i < labels.length; i++)
                NavigationRailDestination(
                    icon: Icon(icons[i]), label: Text(labels[i]))
            ],
          ),
        Expanded(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: pages[selected]))),
      ]),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: selected,
              onDestinationSelected: navigate,
              destinations: [
                for (var i = 0; i < labels.length; i++)
                  NavigationDestination(icon: Icon(icons[i]), label: labels[i])
              ],
            ),
    );
  }
}

/// Owns the controller until the dialog route has finished disposing.
class _SingleTextDialog extends StatefulWidget {
  const _SingleTextDialog({
    required this.title,
    required this.label,
    required this.cancel,
    required this.save,
    this.initialValue = '',
  });

  final String title;
  final String label;
  final String cancel;
  final String save;
  final String initialValue;

  @override
  State<_SingleTextDialog> createState() => _SingleTextDialogState();
}

class _SingleTextDialogState extends State<_SingleTextDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.title),
        content: TextField(
          controller: _controller,
          autofocus: true,
          maxLength: 120,
          decoration: InputDecoration(labelText: widget.label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(widget.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, _controller.text.trim()),
            child: Text(widget.save),
          ),
        ],
      );
}

/// Owns both card controllers for the lifetime of the dialog route.
class _CardTextDialog extends StatefulWidget {
  const _CardTextDialog({
    required this.title,
    required this.frontLabel,
    required this.backLabel,
    required this.cancel,
    required this.save,
    this.initialFront = '',
    this.initialBack = '',
  });

  final String title;
  final String frontLabel;
  final String backLabel;
  final String cancel;
  final String save;
  final String initialFront;
  final String initialBack;

  @override
  State<_CardTextDialog> createState() => _CardTextDialogState();
}

class _CardTextDialogState extends State<_CardTextDialog> {
  late final TextEditingController _front;
  late final TextEditingController _back;

  @override
  void initState() {
    super.initState();
    _front = TextEditingController(text: widget.initialFront);
    _back = TextEditingController(text: widget.initialBack);
  }

  @override
  void dispose() {
    _front.dispose();
    _back.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _front,
                maxLength: 5000,
                decoration: InputDecoration(labelText: widget.frontLabel),
              ),
              TextField(
                controller: _back,
                maxLength: 5000,
                decoration: InputDecoration(labelText: widget.backLabel),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(widget.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, [_front.text, _back.text]),
            child: Text(widget.save),
          ),
        ],
      );
}

class _HomePage extends StatefulWidget {
  const _HomePage({required this.database, required this.onDeckSelected});
  final LocalDatabase database;
  final ValueChanged<String> onDeckSelected;
  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  late Future<List<DeckRecord>> decks;
  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() => decks = widget.database.listDecks();

  Future<void> _addDeck() async {
    final l = AppLocalizations.of(context)!;
    final title = await showDialog<String>(
      context: context,
      builder: (_) => _SingleTextDialog(
        title: l.createDeck,
        label: l.deckName,
        cancel: l.cancel,
        save: l.save,
      ),
    );
    if (title == null || title.isEmpty) return;
    try {
      await widget.database.addDeck(title);
      if (mounted) {
        setState(() {
          _reload();
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                '${AppLocalizations.of(context)!.saveDeckError}: $error')));
      }
    }
  }

  Future<void> _renameDeck(DeckRecord deck) async {
    final title = await showDialog<String>(
      context: context,
      builder: (_) => _SingleTextDialog(
        title: 'Rename deck',
        label: 'Deck name',
        cancel: 'Cancel',
        save: 'Save',
        initialValue: deck.title,
      ),
    );
    if (title == null || title.isEmpty || title == deck.title || !mounted) {
      return;
    }
    try {
      await widget.database.renameDeck(deck.id, title);
      if (mounted) {
        setState(() {
          _reload();
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not rename deck: $error')));
      }
    }
  }

  Future<void> _deleteDeck(DeckRecord deck) async {
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ListView(padding: const EdgeInsets.all(24), children: [
      Text(l.prototypeTitle, style: const TextStyle(fontSize: 26)),
      const SizedBox(height: 12),
      Card(
          child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(l.prototypeDescription))),
      FilledButton.icon(
          onPressed: _addDeck,
          icon: const Icon(Icons.add),
          label: Text(AppLocalizations.of(context)!.createDeck)),
      FutureBuilder<List<DeckRecord>>(
        future: decks,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('${l.storageError}: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return ListTile(title: Text(l.noSavedDecks));
          }
          return Column(children: [
            for (final deck in snapshot.data!)
              ListTile(
                leading: const Icon(Icons.layers_outlined),
                onTap: () => widget.onDeckSelected(deck.id),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Rename deck',
                      onPressed: () => _renameDeck(deck)),
                  IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Delete deck',
                      onPressed: () => _deleteDeck(deck)),
                ]),
                title: Text(deck.title),
                subtitle: Text(
                    '${l.created} ${DateTime.fromMillisecondsSinceEpoch(deck.createdAtMs).toLocal().toIso8601String().split('T').first}'),
              ),
          ]);
        },
      ),
    ]);
  }
}

class _PracticePage extends StatefulWidget {
  const _PracticePage({required this.database, required this.deckId});
  final LocalDatabase database;
  final String? deckId;
  @override
  State<_PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<_PracticePage> {
  Future<List<BasicCardRecord>>? _cards;
  int index = 0;
  bool revealed = false;
  final Set<String> practiced = {};
  String? lastOperationId;
  String? lastCardId;
  bool _ratingBusy = false;
  Future<List<ManagedCardRecord>>? _allCards;
  int _undoLookupGeneration = 0;

  Future<void> _restoreUndo() async {
    final deckId = widget.deckId;
    final generation = ++_undoLookupGeneration;
    if (deckId == null) return;
    try {
      final candidate = await widget.database.latestUndoForDeck(deckId);
      if (!mounted ||
          generation != _undoLookupGeneration ||
          widget.deckId != deckId) {
        return;
      }
      setState(() {
        lastCardId = candidate?.cardId;
        lastOperationId = candidate?.operationId;
      });
    } catch (error) {
      debugPrint('Could not restore review undo: $error');
    }
  }

  void _reloadAllCards() {
    _allCards = widget.deckId == null
        ? null
        : widget.database.listManagedCards(widget.deckId!);
  }

  @override
  void initState() {
    super.initState();
    _reload();
    _reloadAllCards();
    _restoreUndo();
  }

  @override
  void didUpdateWidget(covariant _PracticePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deckId != widget.deckId) {
      index = 0;
      revealed = false;
      practiced.clear();
      _reload();
      _onDeckChanged();
    }
  }

  // Reload Undo only when the selected deck changes.
  void _onDeckChanged() {
    lastCardId = null;
    lastOperationId = null;
    _reloadAllCards();
    _restoreUndo();
  }

  void _reload() {
    _cards = widget.deckId == null
        ? null
        : widget.database.listBasicCards(widget.deckId!);
  }

  Future<void> _addCard() async {
    if (widget.deckId == null) return;
    final l = AppLocalizations.of(context)!;
    final values = await showDialog<List<String>>(
      context: context,
      builder: (_) => _CardTextDialog(
        title: l.createCard,
        frontLabel: l.cardFront,
        backLabel: l.cardBack,
        cancel: l.cancel,
        save: l.save,
      ),
    );
    if (values == null) return;
    try {
      await widget.database.addBasicCard(widget.deckId!, values[0], values[1]);
      if (mounted) {
        setState(() {
          _reloadAllCards();
          _reload();
          index = 0;
          practiced.clear();
          revealed = false;
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.cardSaveError)));
      }
    }
  }

  Future<void> _editCard(ManagedCardRecord card) async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (_) => _CardTextDialog(
        title: 'Edit card',
        frontLabel: 'Front',
        backLabel: 'Back',
        cancel: 'Cancel',
        save: 'Save',
        initialFront: card.front,
        initialBack: card.back,
      ),
    );
    if (result == null || !mounted) return;
    try {
      await widget.database.updateBasicCard(card.id, result[0], result[1]);
      if (mounted) {
        setState(() {
          _reloadAllCards();
          _reload();
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not edit card: $error')));
      }
    }
  }

  Future<void> _deleteCard(ManagedCardRecord card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete card?'),
        content:
            const Text('Delete this card and its review history permanently?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await widget.database.deleteBasicCard(card.id);
      if (mounted) {
        setState(() {
          if (lastCardId == card.id) {
            lastCardId = null;
            lastOperationId = null;
          }
          practiced.remove(card.id);
          _reloadAllCards();
          _reload();
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not delete card: $error')));
      }
    }
  }

  String _dueLabel(int? dueAtMs) {
    if (dueAtMs == null) return 'New / not scheduled';
    final due = DateTime.fromMillisecondsSinceEpoch(dueAtMs).toLocal();
    return 'Next review: ${due.toIso8601String().replaceFirst('T', ' ').split('.').first}';
  }

  /// Ratings are enabled only when the actual native FSRS library loads.
  Future<void> _rate(BasicCardRecord card, int rating) async {
    if (_ratingBusy) return;
    final engine = createFsrsEngine();
    if (engine == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.fsrsNotice)));
      }
      return;
    }
    setState(() => _ratingBusy = true);
    final operationId =
        '${DateTime.now().microsecondsSinceEpoch}_${card.id}_$rating';
    try {
      final saved = await StudyReviewService(widget.database, engine).answer(
        cardId: card.id,
        rating: rating,
        operationId: operationId,
        now: DateTime.now().toUtc(),
      );
      if (saved && mounted) {
        setState(() {
          lastCardId = card.id;
          lastOperationId = operationId;
          practiced.add(card.id);
          _reloadAllCards();
          revealed = false;
          _reload();
        });
      }
    } catch (error) {
      // Do not silently substitute a heuristic scheduling outcome.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.storageError)));
      }
    } finally {
      if (mounted) setState(() => _ratingBusy = false);
    }
  }

  Future<void> _undo() async {
    if (lastCardId == null || lastOperationId == null) return;
    final restored =
        await widget.database.undoLastReview(lastCardId!, lastOperationId!);
    if (restored && mounted) {
      setState(() {
        practiced.remove(lastCardId);
        lastCardId = null;
        lastOperationId = null;
        index = 0;
        revealed = false;
        _reloadAllCards();
        _reload();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (widget.deckId == null) return Center(child: Text(l.selectDeckToStudy));
    return FutureBuilder<List<BasicCardRecord>>(
        future: _cards,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text(l.storageError));
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final cards =
              snapshot.data!.where((e) => !practiced.contains(e.id)).toList();
          final card = cards.isEmpty ? null : cards.first;
          return ListView(padding: const EdgeInsets.all(24), children: [
            FilledButton.icon(
                onPressed: _addCard,
                icon: const Icon(Icons.add),
                label: Text(l.createCard)),
            const SizedBox(height: 12),
            ExpansionTile(
              title: const Text('Manage all cards'),
              subtitle:
                  const Text('Edit, delete, or inspect the next review date'),
              children: [
                if (_allCards != null)
                  FutureBuilder<List<ManagedCardRecord>>(
                    future: _allCards,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Could not load cards');
                      }
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data!.isEmpty) {
                        return const Text('No cards in this deck');
                      }
                      return Column(children: [
                        for (final item in snapshot.data!)
                          ListTile(
                            title: Text(item.front,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text(_dueLabel(item.dueAtMs)),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  tooltip: 'Edit card',
                                  onPressed: () => _editCard(item)),
                              IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  tooltip: 'Delete card',
                                  onPressed: () => _deleteCard(item)),
                            ]),
                          ),
                      ]);
                    },
                  ),
              ],
            ),
            if (lastOperationId != null)
              TextButton.icon(
                  onPressed: _undo,
                  icon: const Icon(Icons.undo),
                  label: Text(l.undoReview)),
            const SizedBox(height: 16),
            if (card == null)
              Center(child: Text(l.noCardsToPractice))
            else ...[
              Card(
                  child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(children: [
                        Text(card.front,
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center),
                        if (revealed) ...[
                          const Divider(height: 36),
                          Text(card.back,
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center)
                        ],
                      ]))),
              if (!revealed)
                FilledButton(
                    onPressed: () => setState(() => revealed = true),
                    child: Text(l.showAnswer))
              else ...[
                const Text(
                  'Review intervals are calculated using FSRS.',
                  textAlign: TextAlign.center,
                ),
                Wrap(alignment: WrapAlignment.center, spacing: 8, children: [
                  OutlinedButton(
                      onPressed: _ratingBusy ? null : () => _rate(card, 1),
                      child: Text(l.again)),
                  OutlinedButton(
                      onPressed: _ratingBusy ? null : () => _rate(card, 2),
                      child: Text(l.hard)),
                  OutlinedButton(
                      onPressed: _ratingBusy ? null : () => _rate(card, 3),
                      child: Text(l.good)),
                  OutlinedButton(
                      onPressed: _ratingBusy ? null : () => _rate(card, 4),
                      child: Text(l.easy)),
                ])
              ],
            ]
          ]);
        });
  }
}

class _ImportPage extends StatelessWidget {
  const _ImportPage();
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.file_open_outlined, size: 60),
        const SizedBox(height: 16),
        Text(l.importTitle),
        const SizedBox(height: 8),
        Text(l.importNotice, textAlign: TextAlign.center),
      ]),
    );
  }
}

class _SettingsPage extends StatelessWidget {
  const _SettingsPage({required this.locale, required this.onLocaleChanged});
  final Locale? locale;
  final ValueChanged<Locale?> onLocaleChanged;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ListView(children: [
      ListTile(
        title: Text(l.language),
        subtitle: Text(l.translationStatus),
        trailing: DropdownButton<String>(
          value: locale?.toLanguageTag() ?? 'system',
          onChanged: (value) {
            if (value == 'system') {
              onLocaleChanged(null);
              return;
            }
            for (final option in AppLocalizations.supportedLocales) {
              if (option.toLanguageTag() == value) {
                onLocaleChanged(option);
                break;
              }
            }
          },
          items: [
            DropdownMenuItem(value: 'system', child: Text(l.systemLanguage)),
            for (final option in AppLocalizations.supportedLocales)
              DropdownMenuItem(
                  value: option.toLanguageTag(),
                  child: Text(option.toLanguageTag())),
          ],
        ),
      ),
      ListTile(title: Text(l.licenses), subtitle: Text(l.licenseNotice)),
      ListTile(title: Text(l.data), subtitle: Text(l.dataNotice)),
      ListTile(title: Text(l.fsrs), subtitle: Text(l.fsrsNotice)),
    ]);
  }
}
