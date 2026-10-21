// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get overview => 'Overview';

  @override
  String get cards => 'Cards';

  @override
  String get importAction => 'Import';

  @override
  String get settings => 'Settings';

  @override
  String get study => 'Study';

  @override
  String get showAnswer => 'Show answer';

  @override
  String get prototypeTitle => 'Research prototype - Phase 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => 'English demo';

  @override
  String get demoJava => 'Java interview demo';

  @override
  String get demoCard => 'Demo card';

  @override
  String get notSaved => 'Answers are not saved; FSRS is not connected.';

  @override
  String get again => 'Again';

  @override
  String get hard => 'Hard';

  @override
  String get good => 'Good';

  @override
  String get easy => 'Easy';

  @override
  String get resetDemo => 'Reset demo';

  @override
  String get importTitle => 'Import / export APKG and COLPKG';

  @override
  String get importNotice =>
      'Not implemented. Archive inspection is available as a separate CLI.';

  @override
  String get licenses => 'Licenses';

  @override
  String get licenseNotice => 'Check third-party licenses before release.';

  @override
  String get data => 'Data';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice =>
      'Native and WebAssembly schedulers are not connected yet.';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'System language';

  @override
  String get translationStatus => 'Interface translations are preliminary.';

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
