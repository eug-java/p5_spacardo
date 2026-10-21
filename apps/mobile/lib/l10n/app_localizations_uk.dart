// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get overview => 'Огляд';

  @override
  String get cards => 'Картки';

  @override
  String get importAction => 'Імпорт';

  @override
  String get settings => 'Налаштування';

  @override
  String get study => 'Вчити';

  @override
  String get showAnswer => 'Показати відповідь';

  @override
  String get prototypeTitle => 'Дослідницький прототип - етап 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => 'Англійська - демо';

  @override
  String get demoJava => 'Співбесіда Java - демо';

  @override
  String get demoCard => 'Демокартка';

  @override
  String get notSaved => 'Відповіді не зберігаються; FSRS ще не підключено.';

  @override
  String get again => 'Знову';

  @override
  String get hard => 'Важко';

  @override
  String get good => 'Добре';

  @override
  String get easy => 'Легко';

  @override
  String get resetDemo => 'Скинути демо';

  @override
  String get importTitle => 'Імпорт і експорт APKG та COLPKG';

  @override
  String get importNotice =>
      'Ще не реалізовано. Є окрема утиліта перевірки архівів.';

  @override
  String get licenses => 'Ліцензії';

  @override
  String get licenseNotice => 'Перевірте ліцензії залежностей перед випуском.';

  @override
  String get data => 'Дані';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice =>
      'Планувальники Native і WebAssembly ще не підключені.';

  @override
  String get language => 'Мова';

  @override
  String get systemLanguage => 'Мова системи';

  @override
  String get translationStatus => 'Переклади інтерфейсу попередні.';

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
