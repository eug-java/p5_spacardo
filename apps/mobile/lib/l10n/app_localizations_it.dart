// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get overview => 'Panoramica';

  @override
  String get cards => 'Schede';

  @override
  String get importAction => 'Importa';

  @override
  String get settings => 'Impostazioni';

  @override
  String get study => 'Studia';

  @override
  String get showAnswer => 'Mostra risposta';

  @override
  String get prototypeTitle => 'Prototipo di ricerca - Fase 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => 'Demo inglese';

  @override
  String get demoJava => 'Demo colloquio Java';

  @override
  String get demoCard => 'Scheda demo';

  @override
  String get notSaved =>
      'Le risposte non vengono salvate; FSRS non è collegato.';

  @override
  String get again => 'Di nuovo';

  @override
  String get hard => 'Difficile';

  @override
  String get good => 'Bene';

  @override
  String get easy => 'Facile';

  @override
  String get resetDemo => 'Reimposta demo';

  @override
  String get importTitle => 'Importa / esporta APKG e COLPKG';

  @override
  String get importNotice =>
      'Non implementato. È disponibile uno strumento separato per gli archivi.';

  @override
  String get licenses => 'Licenze';

  @override
  String get licenseNotice =>
      'Verifica le licenze di terze parti prima del rilascio.';

  @override
  String get data => 'Dati';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice =>
      'Gli scheduler nativi e WebAssembly non sono collegati.';

  @override
  String get language => 'Lingua';

  @override
  String get systemLanguage => 'Lingua di sistema';

  @override
  String get translationStatus => 'Le traduzioni sono preliminari.';

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
