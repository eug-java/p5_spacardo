// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get overview => 'Vue d’ensemble';

  @override
  String get cards => 'Cartes';

  @override
  String get importAction => 'Importer';

  @override
  String get settings => 'Paramètres';

  @override
  String get study => 'Étudier';

  @override
  String get showAnswer => 'Afficher la réponse';

  @override
  String get prototypeTitle => 'Prototype de recherche - Phase 0';

  @override
  String get prototypeDescription =>
      'You can save decks locally. Card editing and scheduled reviews are not implemented yet.';

  @override
  String get demoEnglish => 'Démo anglais';

  @override
  String get demoJava => 'Démo entretien Java';

  @override
  String get demoCard => 'Carte de démonstration';

  @override
  String get notSaved =>
      'Les réponses ne sont pas enregistrées ; FSRS n’est pas connecté.';

  @override
  String get again => 'À revoir';

  @override
  String get hard => 'Difficile';

  @override
  String get good => 'Bien';

  @override
  String get easy => 'Facile';

  @override
  String get resetDemo => 'Réinitialiser';

  @override
  String get importTitle => 'Importer / exporter APKG et COLPKG';

  @override
  String get importNotice =>
      'Non implémenté. Un outil de vérification séparé est disponible.';

  @override
  String get licenses => 'Licences';

  @override
  String get licenseNotice =>
      'Vérifier les licences tierces avant publication.';

  @override
  String get data => 'Données';

  @override
  String get dataNotice =>
      'Decks are stored locally. Backups and export are not implemented yet.';

  @override
  String get fsrs => 'FSRS';

  @override
  String get fsrsNotice =>
      'Les planificateurs natif et WebAssembly ne sont pas connectés.';

  @override
  String get language => 'Langue';

  @override
  String get systemLanguage => 'Langue du système';

  @override
  String get translationStatus => 'Les traductions sont provisoires.';

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
