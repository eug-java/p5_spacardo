// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get overview => 'Przegląd';

  @override
  String get cards => 'Karty';

  @override
  String get importAction => 'Importuj';

  @override
  String get settings => 'Ustawienia';

  @override
  String get study => 'Ucz się';

  @override
  String get showAnswer => 'Pokaż odpowiedź';

  @override
  String get prototypeTitle => 'Prototyp badawczy - Etap 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => 'Demo angielskiego';

  @override
  String get demoJava => 'Demo rozmowy Java';

  @override
  String get demoCard => 'Karta demonstracyjna';

  @override
  String get notSaved =>
      'Odpowiedzi nie są zapisywane; FSRS nie jest podłączony.';

  @override
  String get again => 'Ponownie';

  @override
  String get hard => 'Trudne';

  @override
  String get good => 'Dobrze';

  @override
  String get easy => 'Łatwe';

  @override
  String get resetDemo => 'Zresetuj demo';

  @override
  String get importTitle => 'Import / eksport APKG i COLPKG';

  @override
  String get importNotice =>
      'Jeszcze nie zaimplementowano. Dostępne jest osobne narzędzie kontroli archiwów.';

  @override
  String get licenses => 'Licencje';

  @override
  String get licenseNotice => 'Sprawdź licencje stron trzecich przed wydaniem.';

  @override
  String get data => 'Dane';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice =>
      'Harmonogramy natywne i WebAssembly nie są jeszcze podłączone.';

  @override
  String get language => 'Język';

  @override
  String get systemLanguage => 'Język systemowy';

  @override
  String get translationStatus => 'Tłumaczenia są wstępne.';

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
