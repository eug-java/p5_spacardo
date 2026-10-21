// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get overview => '概要';

  @override
  String get cards => 'カード';

  @override
  String get importAction => 'インポート';

  @override
  String get settings => '設定';

  @override
  String get study => '学習';

  @override
  String get showAnswer => '答えを表示';

  @override
  String get prototypeTitle => '研究用プロトタイプ - フェーズ0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => '英語デモ';

  @override
  String get demoJava => 'Java面接デモ';

  @override
  String get demoCard => 'デモカード';

  @override
  String get notSaved => '回答は保存されず、FSRSは未接続です。';

  @override
  String get again => 'もう一度';

  @override
  String get hard => '難しい';

  @override
  String get good => '普通';

  @override
  String get easy => '簡単';

  @override
  String get resetDemo => 'デモをリセット';

  @override
  String get importTitle => 'APKG / COLPKGのインポート・エクスポート';

  @override
  String get importNotice => '未実装です。別のアーカイブ検査ツールがあります。';

  @override
  String get licenses => 'ライセンス';

  @override
  String get licenseNotice => '公開前に依存ライブラリのライセンスを確認してください。';

  @override
  String get data => 'データ';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice => 'ネイティブとWebAssemblyのスケジューラーは未接続です。';

  @override
  String get language => '言語';

  @override
  String get systemLanguage => 'システム言語';

  @override
  String get translationStatus => '翻訳は暫定版です。';

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
