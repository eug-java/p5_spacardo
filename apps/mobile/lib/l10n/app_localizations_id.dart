// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get overview => 'Ringkasan';

  @override
  String get cards => 'Kartu';

  @override
  String get importAction => 'Impor';

  @override
  String get settings => 'Pengaturan';

  @override
  String get study => 'Belajar';

  @override
  String get showAnswer => 'Tampilkan jawaban';

  @override
  String get prototypeTitle => 'Prototipe riset - Fase 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => 'Demo bahasa Inggris';

  @override
  String get demoJava => 'Demo wawancara Java';

  @override
  String get demoCard => 'Kartu demo';

  @override
  String get notSaved => 'Jawaban tidak disimpan; FSRS belum terhubung.';

  @override
  String get again => 'Lagi';

  @override
  String get hard => 'Sulit';

  @override
  String get good => 'Baik';

  @override
  String get easy => 'Mudah';

  @override
  String get resetDemo => 'Atur ulang demo';

  @override
  String get importTitle => 'Impor / ekspor APKG dan COLPKG';

  @override
  String get importNotice =>
      'Belum diterapkan. Alat pemeriksa arsip tersedia terpisah.';

  @override
  String get licenses => 'Lisensi';

  @override
  String get licenseNotice => 'Periksa lisensi pihak ketiga sebelum rilis.';

  @override
  String get data => 'Data';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice => 'Penjadwal native dan WebAssembly belum terhubung.';

  @override
  String get language => 'Bahasa';

  @override
  String get systemLanguage => 'Bahasa sistem';

  @override
  String get translationStatus => 'Terjemahan antarmuka masih awal.';

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
