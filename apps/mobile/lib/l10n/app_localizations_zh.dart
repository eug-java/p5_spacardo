// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get overview => '概览';

  @override
  String get cards => '卡片';

  @override
  String get importAction => '导入';

  @override
  String get settings => '设置';

  @override
  String get study => '学习';

  @override
  String get showAnswer => '显示答案';

  @override
  String get prototypeTitle => '研究原型 - 阶段 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => '英语演示';

  @override
  String get demoJava => 'Java 面试演示';

  @override
  String get demoCard => '演示卡片';

  @override
  String get notSaved => '答案不会保存；FSRS 尚未连接。';

  @override
  String get again => '重来';

  @override
  String get hard => '困难';

  @override
  String get good => '良好';

  @override
  String get easy => '简单';

  @override
  String get resetDemo => '重置演示';

  @override
  String get importTitle => '导入 / 导出 APKG 和 COLPKG';

  @override
  String get importNotice => '尚未实现；可以使用单独的存档检查工具。';

  @override
  String get licenses => '许可证';

  @override
  String get licenseNotice => '发布前请检查第三方许可证。';

  @override
  String get data => '数据';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice => '原生和 WebAssembly 调度器尚未连接。';

  @override
  String get language => '语言';

  @override
  String get systemLanguage => '系统语言';

  @override
  String get translationStatus => '界面翻译尚属初稿。';

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

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get overview => '概览';

  @override
  String get cards => '卡片';

  @override
  String get importAction => '导入';

  @override
  String get settings => '设置';

  @override
  String get study => '学习';

  @override
  String get showAnswer => '显示答案';

  @override
  String get prototypeTitle => '研究原型 - 阶段 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => '英语演示';

  @override
  String get demoJava => 'Java 面试演示';

  @override
  String get demoCard => '演示卡片';

  @override
  String get notSaved => '答案不会保存；FSRS 尚未连接。';

  @override
  String get again => '重来';

  @override
  String get hard => '困难';

  @override
  String get good => '良好';

  @override
  String get easy => '简单';

  @override
  String get resetDemo => '重置演示';

  @override
  String get importTitle => '导入 / 导出 APKG 和 COLPKG';

  @override
  String get importNotice => '尚未实现；可以使用单独的存档检查工具。';

  @override
  String get licenses => '许可证';

  @override
  String get licenseNotice => '发布前请检查第三方许可证。';

  @override
  String get data => '数据';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice => '原生和 WebAssembly 调度器尚未连接。';

  @override
  String get language => '语言';

  @override
  String get systemLanguage => '系统语言';

  @override
  String get translationStatus => '界面翻译尚属初稿。';

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

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get overview => '總覽';

  @override
  String get cards => '卡片';

  @override
  String get importAction => '匯入';

  @override
  String get settings => '設定';

  @override
  String get study => '學習';

  @override
  String get showAnswer => '顯示答案';

  @override
  String get prototypeTitle => '研究原型 - 階段 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => '英文示範';

  @override
  String get demoJava => 'Java 面試示範';

  @override
  String get demoCard => '示範卡片';

  @override
  String get notSaved => '答案不會儲存；FSRS 尚未連接。';

  @override
  String get again => '重來';

  @override
  String get hard => '困難';

  @override
  String get good => '良好';

  @override
  String get easy => '簡單';

  @override
  String get resetDemo => '重設示範';

  @override
  String get importTitle => '匯入 / 匯出 APKG 和 COLPKG';

  @override
  String get importNotice => '尚未實作；可使用獨立的封存檢查工具。';

  @override
  String get licenses => '授權';

  @override
  String get licenseNotice => '發布前請檢查第三方授權。';

  @override
  String get data => '資料';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice => '原生和 WebAssembly 排程器尚未連接。';

  @override
  String get language => '語言';

  @override
  String get systemLanguage => '系統語言';

  @override
  String get translationStatus => '介面翻譯尚為初稿。';

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
