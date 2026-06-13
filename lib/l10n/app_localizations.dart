import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
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
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Reflexive Agent'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @prompts.
  ///
  /// In en, this message translates to:
  /// **'Prompts'**
  String get prompts;

  /// No description provided for @iteration.
  ///
  /// In en, this message translates to:
  /// **'Iteration: {count}'**
  String iteration(int count);

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {seconds}s'**
  String remaining(int seconds);

  /// No description provided for @critic.
  ///
  /// In en, this message translates to:
  /// **'Critic:'**
  String get critic;

  /// No description provided for @generatorDraft.
  ///
  /// In en, this message translates to:
  /// **'Generator (Draft):'**
  String get generatorDraft;

  /// No description provided for @stoppingCriteria.
  ///
  /// In en, this message translates to:
  /// **'Stopping Criteria'**
  String get stoppingCriteria;

  /// No description provided for @maxDuration.
  ///
  /// In en, this message translates to:
  /// **'Max Duration (seconds)'**
  String get maxDuration;

  /// No description provided for @maxIterations.
  ///
  /// In en, this message translates to:
  /// **'Max Iterations'**
  String get maxIterations;

  /// No description provided for @requestDelay.
  ///
  /// In en, this message translates to:
  /// **'Request Delay (ms)'**
  String get requestDelay;

  /// No description provided for @requestDelaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delay between API calls to avoid rate limits'**
  String get requestDelaySubtitle;

  /// No description provided for @stopIfNoIssues.
  ///
  /// In en, this message translates to:
  /// **'Stop if no issues found'**
  String get stopIfNoIssues;

  /// No description provided for @stopIfNoIssuesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exit early if the Critic finds no flaws'**
  String get stopIfNoIssuesSubtitle;

  /// No description provided for @reflectionStrategy.
  ///
  /// In en, this message translates to:
  /// **'Reflection Strategy'**
  String get reflectionStrategy;

  /// No description provided for @llmConfiguration.
  ///
  /// In en, this message translates to:
  /// **'LLM Configuration'**
  String get llmConfiguration;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @apiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKey;

  /// No description provided for @baseUrl.
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get baseUrl;

  /// No description provided for @modelName.
  ///
  /// In en, this message translates to:
  /// **'Model Name'**
  String get modelName;

  /// No description provided for @modelNameHelper.
  ///
  /// In en, this message translates to:
  /// **'Type \"auto\" or \"default\" to use provider recommended model'**
  String get modelNameHelper;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get resetToDefault;

  /// No description provided for @resetToProviderDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to provider default'**
  String get resetToProviderDefault;

  /// No description provided for @systemArchitecture.
  ///
  /// In en, this message translates to:
  /// **'System Architecture'**
  String get systemArchitecture;

  /// No description provided for @systemArchitectureHelper.
  ///
  /// In en, this message translates to:
  /// **'General instructions for the agent'**
  String get systemArchitectureHelper;

  /// No description provided for @mathFormatting.
  ///
  /// In en, this message translates to:
  /// **'Math Formatting'**
  String get mathFormatting;

  /// No description provided for @mathFormattingHelper.
  ///
  /// In en, this message translates to:
  /// **'Instructions for LaTeX output'**
  String get mathFormattingHelper;

  /// No description provided for @generatorRole.
  ///
  /// In en, this message translates to:
  /// **'Generator Role'**
  String get generatorRole;

  /// No description provided for @generatorRoleHelper.
  ///
  /// In en, this message translates to:
  /// **'Prompt for creating the first draft'**
  String get generatorRoleHelper;

  /// No description provided for @criticRole.
  ///
  /// In en, this message translates to:
  /// **'Critic Role (Standard)'**
  String get criticRole;

  /// No description provided for @criticRoleHelper.
  ///
  /// In en, this message translates to:
  /// **'Prompt for standard self-review'**
  String get criticRoleHelper;

  /// No description provided for @devilsAdvocateRole.
  ///
  /// In en, this message translates to:
  /// **'Devil\'s Advocate Role'**
  String get devilsAdvocateRole;

  /// No description provided for @devilsAdvocateRoleHelper.
  ///
  /// In en, this message translates to:
  /// **'Prompt for aggressive critique'**
  String get devilsAdvocateRoleHelper;

  /// No description provided for @editorRole.
  ///
  /// In en, this message translates to:
  /// **'Editor Role'**
  String get editorRole;

  /// No description provided for @editorRoleHelper.
  ///
  /// In en, this message translates to:
  /// **'Prompt for the final polishing stage'**
  String get editorRoleHelper;

  /// No description provided for @exportPrompts.
  ///
  /// In en, this message translates to:
  /// **'Export Prompts'**
  String get exportPrompts;

  /// No description provided for @importPrompts.
  ///
  /// In en, this message translates to:
  /// **'Import Prompts'**
  String get importPrompts;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Prompts exported to clipboard'**
  String get exportSuccess;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Prompts imported successfully'**
  String get importSuccess;

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'Failed to import prompts: Invalid format'**
  String get importError;

  /// No description provided for @useInternet.
  ///
  /// In en, this message translates to:
  /// **'Enable Internet Search'**
  String get useInternet;

  /// No description provided for @useInternetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow the model to access the web for up-to-date information (if supported by provider)'**
  String get useInternetSubtitle;
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
    'en',
    'es',
    'fr',
    'hi',
    'ja',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
