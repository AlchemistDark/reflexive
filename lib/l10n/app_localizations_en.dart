// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Reflexive Agent';

  @override
  String get settings => 'Settings';

  @override
  String get general => 'General';

  @override
  String get prompts => 'Prompts';

  @override
  String iteration(int count) {
    return 'Iteration: $count';
  }

  @override
  String remaining(int seconds) {
    return 'Remaining: ${seconds}s';
  }

  @override
  String get critic => 'Critic:';

  @override
  String get generatorDraft => 'Generator (Draft):';

  @override
  String get stoppingCriteria => 'Stopping Criteria';

  @override
  String get maxDuration => 'Max Duration (seconds)';

  @override
  String get maxIterations => 'Max Iterations';

  @override
  String get requestDelay => 'Request Delay (ms)';

  @override
  String get requestDelaySubtitle =>
      'Delay between API calls to avoid rate limits';

  @override
  String get stopIfNoIssues => 'Stop if no issues found';

  @override
  String get stopIfNoIssuesSubtitle =>
      'Exit early if the Critic finds no flaws';

  @override
  String get reflectionStrategy => 'Reflection Strategy';

  @override
  String get llmConfiguration => 'LLM Configuration';

  @override
  String get provider => 'Provider';

  @override
  String get apiKey => 'API Key';

  @override
  String get baseUrl => 'Base URL';

  @override
  String get modelName => 'Model Name';

  @override
  String get modelNameHelper =>
      'Type \"auto\" or \"default\" to use provider recommended model';

  @override
  String get resetToDefault => 'Reset to default';

  @override
  String get resetToProviderDefault => 'Reset to provider default';

  @override
  String get systemArchitecture => 'System Architecture';

  @override
  String get systemArchitectureHelper => 'General instructions for the agent';

  @override
  String get mathFormatting => 'Math Formatting';

  @override
  String get mathFormattingHelper => 'Instructions for LaTeX output';

  @override
  String get generatorRole => 'Generator Role';

  @override
  String get generatorRoleHelper => 'Prompt for creating the first draft';

  @override
  String get criticRole => 'Critic Role (Standard)';

  @override
  String get criticRoleHelper => 'Prompt for standard self-review';

  @override
  String get devilsAdvocateRole => 'Devil\'s Advocate Role';

  @override
  String get devilsAdvocateRoleHelper => 'Prompt for aggressive critique';

  @override
  String get editorRole => 'Editor Role';

  @override
  String get editorRoleHelper => 'Prompt for the final polishing stage';

  @override
  String get exportPrompts => 'Export Prompts';

  @override
  String get importPrompts => 'Import Prompts';

  @override
  String get exportSuccess => 'Prompts exported to clipboard';

  @override
  String get importSuccess => 'Prompts imported successfully';

  @override
  String get importError => 'Failed to import prompts: Invalid format';

  @override
  String get useInternet => 'Enable Internet Search';

  @override
  String get useInternetSubtitle =>
      'Allow the model to access the web for up-to-date information (if supported by provider)';
}
