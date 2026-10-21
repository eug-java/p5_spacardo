// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get overview => 'نظرة عامة';

  @override
  String get cards => 'البطاقات';

  @override
  String get importAction => 'استيراد';

  @override
  String get settings => 'الإعدادات';

  @override
  String get study => 'دراسة';

  @override
  String get showAnswer => 'إظهار الإجابة';

  @override
  String get prototypeTitle => 'نموذج بحثي - المرحلة 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => 'تجربة الإنجليزية';

  @override
  String get demoJava => 'تجربة مقابلة Java';

  @override
  String get demoCard => 'بطاقة تجريبية';

  @override
  String get notSaved => 'لا تُحفظ الإجابات؛ لم يتم ربط FSRS بعد.';

  @override
  String get again => 'مرة أخرى';

  @override
  String get hard => 'صعب';

  @override
  String get good => 'جيد';

  @override
  String get easy => 'سهل';

  @override
  String get resetDemo => 'إعادة ضبط التجربة';

  @override
  String get importTitle => 'استيراد / تصدير APKG وCOLPKG';

  @override
  String get importNotice =>
      'لم يتم التنفيذ بعد. توجد أداة منفصلة لفحص الأرشيف.';

  @override
  String get licenses => 'التراخيص';

  @override
  String get licenseNotice => 'تحقق من تراخيص الأطراف الأخرى قبل الإصدار.';

  @override
  String get data => 'البيانات';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice => 'لم يتم ربط مجدولي Native وWebAssembly بعد.';

  @override
  String get language => 'اللغة';

  @override
  String get systemLanguage => 'لغة النظام';

  @override
  String get translationStatus => 'الترجمات أولية.';

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
