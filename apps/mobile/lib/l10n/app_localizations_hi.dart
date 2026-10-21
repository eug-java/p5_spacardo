// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get overview => 'अवलोकन';

  @override
  String get cards => 'कार्ड';

  @override
  String get importAction => 'आयात';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get study => 'अध्ययन';

  @override
  String get showAnswer => 'उत्तर दिखाएँ';

  @override
  String get prototypeTitle => 'अनुसंधान प्रोटोटाइप - चरण 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => 'अंग्रेज़ी डेमो';

  @override
  String get demoJava => 'Java साक्षात्कार डेमो';

  @override
  String get demoCard => 'डेमो कार्ड';

  @override
  String get notSaved => 'उत्तर सहेजे नहीं जाते; FSRS अभी जुड़ा नहीं है।';

  @override
  String get again => 'फिर से';

  @override
  String get hard => 'कठिन';

  @override
  String get good => 'अच्छा';

  @override
  String get easy => 'आसान';

  @override
  String get resetDemo => 'डेमो रीसेट करें';

  @override
  String get importTitle => 'APKG और COLPKG आयात / निर्यात';

  @override
  String get importNotice =>
      'अभी लागू नहीं किया गया है। अलग संग्रह जाँच उपकरण उपलब्ध है।';

  @override
  String get licenses => 'लाइसेंस';

  @override
  String get licenseNotice => 'रिलीज़ से पहले तृतीय-पक्ष लाइसेंस जाँचें।';

  @override
  String get data => 'डेटा';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice => 'नेटिव और WebAssembly शेड्यूलर अभी जुड़े नहीं हैं।';

  @override
  String get language => 'भाषा';

  @override
  String get systemLanguage => 'सिस्टम भाषा';

  @override
  String get translationStatus => 'अनुवाद प्रारंभिक हैं।';

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
