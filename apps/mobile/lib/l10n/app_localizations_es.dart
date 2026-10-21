// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get overview => 'Resumen';

  @override
  String get cards => 'Tarjetas';

  @override
  String get importAction => 'Importar';

  @override
  String get settings => 'Ajustes';

  @override
  String get study => 'Estudiar';

  @override
  String get showAnswer => 'Mostrar respuesta';

  @override
  String get prototypeTitle => 'Prototipo de investigación - Fase 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => 'Demostración de inglés';

  @override
  String get demoJava => 'Demostración de entrevista Java';

  @override
  String get demoCard => 'Tarjeta de ejemplo';

  @override
  String get notSaved =>
      'Las respuestas no se guardan; FSRS no está conectado.';

  @override
  String get again => 'Otra vez';

  @override
  String get hard => 'Difícil';

  @override
  String get good => 'Bien';

  @override
  String get easy => 'Fácil';

  @override
  String get resetDemo => 'Reiniciar';

  @override
  String get importTitle => 'Importar / exportar APKG y COLPKG';

  @override
  String get importNotice =>
      'No implementado. Hay una herramienta de inspección independiente.';

  @override
  String get licenses => 'Licencias';

  @override
  String get licenseNotice =>
      'Verifica las licencias de terceros antes del lanzamiento.';

  @override
  String get data => 'Datos';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice =>
      'Los planificadores nativo y WebAssembly aún no están conectados.';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Idioma del sistema';

  @override
  String get translationStatus => 'Las traducciones son preliminares.';

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
