// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get overview => 'Genel bakış';

  @override
  String get cards => 'Kartlar';

  @override
  String get importAction => 'İçe aktar';

  @override
  String get settings => 'Ayarlar';

  @override
  String get study => 'Çalış';

  @override
  String get showAnswer => 'Yanıtı göster';

  @override
  String get prototypeTitle => 'Araştırma prototipi - Aşama 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => 'İngilizce demo';

  @override
  String get demoJava => 'Java mülakat demosu';

  @override
  String get demoCard => 'Demo kartı';

  @override
  String get notSaved => 'Yanıtlar kaydedilmez; FSRS bağlı değil.';

  @override
  String get again => 'Tekrar';

  @override
  String get hard => 'Zor';

  @override
  String get good => 'İyi';

  @override
  String get easy => 'Kolay';

  @override
  String get resetDemo => 'Demoyu sıfırla';

  @override
  String get importTitle => 'APKG ve COLPKG içe / dışa aktar';

  @override
  String get importNotice =>
      'Henüz uygulanmadı. Ayrı bir arşiv denetleyicisi mevcut.';

  @override
  String get licenses => 'Lisanslar';

  @override
  String get licenseNotice =>
      'Yayınlamadan önce üçüncü taraf lisanslarını denetleyin.';

  @override
  String get data => 'Veriler';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice =>
      'Native ve WebAssembly zamanlayıcıları henüz bağlı değil.';

  @override
  String get language => 'Dil';

  @override
  String get systemLanguage => 'Sistem dili';

  @override
  String get translationStatus => 'Arayüz çevirileri taslaktır.';

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
