// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get overview => '개요';

  @override
  String get cards => '카드';

  @override
  String get importAction => '가져오기';

  @override
  String get settings => '설정';

  @override
  String get study => '학습';

  @override
  String get showAnswer => '정답 보기';

  @override
  String get prototypeTitle => '연구용 프로토타입 - 0단계';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => '영어 데모';

  @override
  String get demoJava => 'Java 면접 데모';

  @override
  String get demoCard => '데모 카드';

  @override
  String get notSaved => '답변은 저장되지 않으며 FSRS는 연결되지 않았습니다.';

  @override
  String get again => '다시';

  @override
  String get hard => '어려움';

  @override
  String get good => '보통';

  @override
  String get easy => '쉬움';

  @override
  String get resetDemo => '데모 초기화';

  @override
  String get importTitle => 'APKG / COLPKG 가져오기 및 내보내기';

  @override
  String get importNotice => '아직 구현되지 않았습니다. 별도 압축 파일 검사 도구가 있습니다.';

  @override
  String get licenses => '라이선스';

  @override
  String get licenseNotice => '출시 전에 타사 라이선스를 확인하세요.';

  @override
  String get data => '데이터';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice => '네이티브 및 WebAssembly 스케줄러가 연결되지 않았습니다.';

  @override
  String get language => '언어';

  @override
  String get systemLanguage => '시스템 언어';

  @override
  String get translationStatus => '번역은 임시 버전입니다.';

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
