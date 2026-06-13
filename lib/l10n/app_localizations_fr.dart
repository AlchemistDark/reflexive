// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Agent Réflexif';

  @override
  String get settings => 'Paramètres';

  @override
  String get general => 'Général';

  @override
  String get prompts => 'Prompts';

  @override
  String iteration(int count) {
    return 'Itération : $count';
  }

  @override
  String remaining(int seconds) {
    return 'Restant : ${seconds}s';
  }

  @override
  String get critic => 'Critique :';

  @override
  String get generatorDraft => 'Générateur (Brouillon) :';

  @override
  String get stoppingCriteria => 'Critères d\'arrêt';

  @override
  String get maxDuration => 'Durée maximale (secondes)';

  @override
  String get maxIterations => 'Itérations maximales';

  @override
  String get requestDelay => 'Délai de requête (ms)';

  @override
  String get requestDelaySubtitle =>
      'Délai entre les appels API pour éviter les limites de débit';

  @override
  String get stopIfNoIssues => 'Arrêter si aucun problème';

  @override
  String get stopIfNoIssuesSubtitle =>
      'Quitter prématurément si le Critique ne trouve aucun défaut';

  @override
  String get reflectionStrategy => 'Stratégie de réflexion';

  @override
  String get llmConfiguration => 'Configuration LLM';

  @override
  String get provider => 'Fournisseur';

  @override
  String get apiKey => 'Clé API';

  @override
  String get baseUrl => 'URL de base';

  @override
  String get modelName => 'Nom du modèle';

  @override
  String get modelNameHelper =>
      'Tapez \"auto\" ou \"default\" pour utiliser le modèle recommandé';

  @override
  String get resetToDefault => 'Réinitialiser';

  @override
  String get resetToProviderDefault => 'Réinitialiser aux valeurs par défaut';

  @override
  String get systemArchitecture => 'Architecture système';

  @override
  String get systemArchitectureHelper => 'Instructions générales pour l\'agent';

  @override
  String get mathFormatting => 'Formatage mathématique';

  @override
  String get mathFormattingHelper => 'Instructions pour la sortie LaTeX';

  @override
  String get generatorRole => 'Rôle du Générateur';

  @override
  String get generatorRoleHelper => 'Prompt pour créer le premier brouillon';

  @override
  String get criticRole => 'Rôle du Critique (Standard)';

  @override
  String get criticRoleHelper => 'Prompt pour l\'auto-examen standard';

  @override
  String get devilsAdvocateRole => 'Rôle de l\'Avocat du Diable';

  @override
  String get devilsAdvocateRoleHelper => 'Prompt pour une critique agressive';

  @override
  String get editorRole => 'Rôle de l\'Éditeur';

  @override
  String get editorRoleHelper => 'Prompt pour l\'étape de polissage final';

  @override
  String get exportPrompts => 'Exporter les prompts';

  @override
  String get importPrompts => 'Importer les prompts';

  @override
  String get exportSuccess => 'Prompts exportés dans le presse-papiers';

  @override
  String get importSuccess => 'Prompts importés avec succès';

  @override
  String get importError =>
      'Échec de l\'importation des prompts : Format invalide';

  @override
  String get useInternet => 'Enable Internet Search';

  @override
  String get useInternetSubtitle =>
      'Allow the model to access the web for up-to-date information (if supported by provider)';
}
