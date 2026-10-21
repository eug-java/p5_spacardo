// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get overview => 'Tổng quan';

  @override
  String get cards => 'Thẻ';

  @override
  String get importAction => 'Nhập';

  @override
  String get settings => 'Cài đặt';

  @override
  String get study => 'Học';

  @override
  String get showAnswer => 'Hiện đáp án';

  @override
  String get prototypeTitle => 'Bản thử nghiệm nghiên cứu - Giai đoạn 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => 'Demo tiếng Anh';

  @override
  String get demoJava => 'Demo phỏng vấn Java';

  @override
  String get demoCard => 'Thẻ demo';

  @override
  String get notSaved => 'Câu trả lời không được lưu; FSRS chưa kết nối.';

  @override
  String get again => 'Lại';

  @override
  String get hard => 'Khó';

  @override
  String get good => 'Tốt';

  @override
  String get easy => 'Dễ';

  @override
  String get resetDemo => 'Đặt lại demo';

  @override
  String get importTitle => 'Nhập / xuất APKG và COLPKG';

  @override
  String get importNotice =>
      'Chưa triển khai. Có công cụ kiểm tra tệp nén riêng.';

  @override
  String get licenses => 'Giấy phép';

  @override
  String get licenseNotice =>
      'Kiểm tra giấy phép bên thứ ba trước khi phát hành.';

  @override
  String get data => 'Dữ liệu';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice =>
      'Bộ lập lịch Native và WebAssembly chưa được kết nối.';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get systemLanguage => 'Ngôn ngữ hệ thống';

  @override
  String get translationStatus => 'Bản dịch giao diện là bản sơ bộ.';

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
