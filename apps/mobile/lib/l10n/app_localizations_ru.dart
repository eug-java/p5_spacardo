// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get overview => 'Обзор';

  @override
  String get cards => 'Карточки';

  @override
  String get importAction => 'Импорт';

  @override
  String get settings => 'Настройки';

  @override
  String get study => 'Учить';

  @override
  String get showAnswer => 'Показать ответ';

  @override
  String get prototypeTitle => 'Исследовательский прототип - этап 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => 'Английский - демо';

  @override
  String get demoJava => 'Интервью Java - демо';

  @override
  String get demoCard => 'Демо-карточка';

  @override
  String get notSaved => 'Ответы не сохраняются; FSRS пока не подключён.';

  @override
  String get again => 'Снова';

  @override
  String get hard => 'Трудно';

  @override
  String get good => 'Хорошо';

  @override
  String get easy => 'Легко';

  @override
  String get resetDemo => 'Сбросить демо';

  @override
  String get importTitle => 'Импорт и экспорт APKG и COLPKG';

  @override
  String get importNotice =>
      'Ещё не реализовано. Есть отдельная утилита проверки архивов.';

  @override
  String get licenses => 'Лицензии';

  @override
  String get licenseNotice => 'Перед выпуском проверьте лицензии зависимостей.';

  @override
  String get data => 'Данные';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice =>
      'Планировщики Native и WebAssembly пока не подключены.';

  @override
  String get language => 'Язык';

  @override
  String get systemLanguage => 'Язык системы';

  @override
  String get translationStatus => 'Переводы интерфейса предварительные.';

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
