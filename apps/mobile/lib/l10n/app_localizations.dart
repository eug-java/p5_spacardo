import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cards;

  /// No description provided for @importAction.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importAction;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @study.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get study;

  /// Reveal a flashcard answer
  ///
  /// In en, this message translates to:
  /// **'Show answer'**
  String get showAnswer;

  /// No description provided for @prototypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Research prototype - Phase 0'**
  String get prototypeTitle;

  /// No description provided for @prototypeDescription.
  ///
  /// In en, this message translates to:
  /// **'You can save decks locally. Card editing and scheduled reviews are not implemented yet.'**
  String get prototypeDescription;

  /// No description provided for @demoEnglish.
  ///
  /// In en, this message translates to:
  /// **'English demo'**
  String get demoEnglish;

  /// No description provided for @demoJava.
  ///
  /// In en, this message translates to:
  /// **'Java interview demo'**
  String get demoJava;

  /// No description provided for @demoCard.
  ///
  /// In en, this message translates to:
  /// **'Demo card'**
  String get demoCard;

  /// No description provided for @notSaved.
  ///
  /// In en, this message translates to:
  /// **'Answers are not saved; FSRS is not connected.'**
  String get notSaved;

  /// No description provided for @again.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get again;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @resetDemo.
  ///
  /// In en, this message translates to:
  /// **'Reset demo'**
  String get resetDemo;

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Import / export APKG and COLPKG'**
  String get importTitle;

  /// No description provided for @importNotice.
  ///
  /// In en, this message translates to:
  /// **'Not implemented. Archive inspection is available as a separate CLI.'**
  String get importNotice;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @licenseNotice.
  ///
  /// In en, this message translates to:
  /// **'Check third-party licenses before release.'**
  String get licenseNotice;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @dataNotice.
  ///
  /// In en, this message translates to:
  /// **'Decks are stored locally. Backups and export are not implemented yet.'**
  String get dataNotice;

  /// No description provided for @fsrs.
  ///
  /// In en, this message translates to:
  /// **'FSRS'**
  String get fsrs;

  /// No description provided for @fsrsNotice.
  ///
  /// In en, this message translates to:
  /// **'Native and WebAssembly schedulers are not connected yet.'**
  String get fsrsNotice;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get systemLanguage;

  /// No description provided for @translationStatus.
  ///
  /// In en, this message translates to:
  /// **'Interface translations are preliminary.'**
  String get translationStatus;

  /// No description provided for @createDeck.
  ///
  /// In en, this message translates to:
  /// **'Create deck'**
  String get createDeck;

  /// No description provided for @deckName.
  ///
  /// In en, this message translates to:
  /// **'Deck name'**
  String get deckName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @noDecks.
  ///
  /// In en, this message translates to:
  /// **'No saved decks yet'**
  String get noDecks;

  /// No description provided for @storageError.
  ///
  /// In en, this message translates to:
  /// **'Storage unavailable'**
  String get storageError;

  /// No description provided for @saveDeckError.
  ///
  /// In en, this message translates to:
  /// **'Could not save deck'**
  String get saveDeckError;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @createCard.
  ///
  /// In en, this message translates to:
  /// **'Add card'**
  String get createCard;

  /// No description provided for @cardFront.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get cardFront;

  /// No description provided for @cardBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get cardBack;

  /// No description provided for @cardSaveError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save card'**
  String get cardSaveError;

  /// No description provided for @practiceSaveError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save practice result'**
  String get practiceSaveError;

  /// No description provided for @selectDeckToStudy.
  ///
  /// In en, this message translates to:
  /// **'Select a deck on the Home screen first'**
  String get selectDeckToStudy;

  /// No description provided for @noCardsToPractice.
  ///
  /// In en, this message translates to:
  /// **'No unpracticed cards in this session'**
  String get noCardsToPractice;

  /// No description provided for @practiceOnlyDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Practice mode: ratings are saved, but FSRS scheduling is not connected yet.'**
  String get practiceOnlyDisclaimer;

  /// No description provided for @noSavedDecks.
  ///
  /// In en, this message translates to:
  /// **'No saved decks yet'**
  String get noSavedDecks;

  /// No description provided for @undoReview.
  ///
  /// In en, this message translates to:
  /// **'Undo last review'**
  String get undoReview;

  /// No description provided for @provisionalSchedulingNotice.
  ///
  /// In en, this message translates to:
  /// **'Temporary scheduling only; FSRS is not connected yet.'**
  String get provisionalSchedulingNotice;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'id',
        'it',
        'ja',
        'ko',
        'pl',
        'pt',
        'ru',
        'tr',
        'uk',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
