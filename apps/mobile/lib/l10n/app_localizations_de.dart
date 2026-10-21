// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get overview => 'Übersicht';

  @override
  String get cards => 'Karten';

  @override
  String get importAction => 'Importieren';

  @override
  String get settings => 'Einstellungen';

  @override
  String get study => 'Lernen';

  @override
  String get showAnswer => 'Antwort anzeigen';

  @override
  String get prototypeTitle => 'Forschungsprototyp - Phase 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => 'Englisch-Demo';

  @override
  String get demoJava => 'Java-Interview-Demo';

  @override
  String get demoCard => 'Demokarte';

  @override
  String get notSaved =>
      'Antworten werden nicht gespeichert; FSRS ist nicht verbunden.';

  @override
  String get again => 'Nochmal';

  @override
  String get hard => 'Schwer';

  @override
  String get good => 'Gut';

  @override
  String get easy => 'Einfach';

  @override
  String get resetDemo => 'Demo zurücksetzen';

  @override
  String get importTitle => 'APKG und COLPKG importieren / exportieren';

  @override
  String get importNotice =>
      'Noch nicht implementiert. Ein separates Prüfwerkzeug ist verfügbar.';

  @override
  String get licenses => 'Lizenzen';

  @override
  String get licenseNotice => 'Drittlizenzen vor der Veröffentlichung prüfen.';

  @override
  String get data => 'Daten';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice =>
      'Native und WebAssembly-Planer sind noch nicht verbunden.';

  @override
  String get language => 'Sprache';

  @override
  String get systemLanguage => 'Systemsprache';

  @override
  String get translationStatus => 'Die Übersetzungen sind vorläufig.';

  @override
  String get createDeck => 'Create deck';

  @override
  String get deckName => 'Deck name';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get noDecks => 'No saved decks yet';

  @override
  String get storageError => 'Storage unavailable';

  @override
  String get saveDeckError => 'Could not save deck';

  @override
  String get created => 'Created';

  @override
  String get createCard => 'Add card';

  @override
  String get cardFront => 'Front';

  @override
  String get cardBack => 'Back';

  @override
  String get cardSaveError => 'Unable to save card';

  @override
  String get practiceSaveError => 'Unable to save practice result';

  @override
  String get selectDeckToStudy => 'Select a deck on the Home screen first';

  @override
  String get noCardsToPractice => 'No unpracticed cards in this session';

  @override
  String get practiceOnlyDisclaimer =>
      'Practice mode: ratings are saved, but FSRS scheduling is not connected yet.';

  @override
  String get noSavedDecks => 'No saved decks yet';

  @override
  String get undoReview => 'Undo last review';

  @override
  String get provisionalSchedulingNotice =>
      'Temporary scheduling only; FSRS is not connected yet.';
}
