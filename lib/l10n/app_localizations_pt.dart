// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Agente Reflexivo';

  @override
  String get settings => 'Configurações';

  @override
  String get general => 'Geral';

  @override
  String get prompts => 'Prompts';

  @override
  String iteration(int count) {
    return 'Iteração: $count';
  }

  @override
  String remaining(int seconds) {
    return 'Restante: ${seconds}s';
  }

  @override
  String get critic => 'Crítico:';

  @override
  String get generatorDraft => 'Gerador (Rascunho):';

  @override
  String get stoppingCriteria => 'Critérios de parada';

  @override
  String get maxDuration => 'Duração máxima (segundos)';

  @override
  String get maxIterations => 'Máximo de iterações';

  @override
  String get requestDelay => 'Atraso de solicitação (ms)';

  @override
  String get requestDelaySubtitle =>
      'Atraso entre chamadas de API para evitar limites';

  @override
  String get stopIfNoIssues => 'Parar se não houver problemas';

  @override
  String get stopIfNoIssuesSubtitle =>
      'Sair cedo se o Crítico não encontrar falhas';

  @override
  String get reflectionStrategy => 'Estratégia de reflexão';

  @override
  String get llmConfiguration => 'Configuração do LLM';

  @override
  String get provider => 'Provedor';

  @override
  String get apiKey => 'Chave API';

  @override
  String get baseUrl => 'URL base';

  @override
  String get modelName => 'Nome do modelo';

  @override
  String get modelNameHelper =>
      'Digite \"auto\" ou \"default\" para usar o modelo recomendado';

  @override
  String get resetToDefault => 'Redefinir';

  @override
  String get resetToProviderDefault => 'Redefinir para o padrão do provedor';

  @override
  String get systemArchitecture => 'Arquitetura do sistema';

  @override
  String get systemArchitectureHelper => 'Instruções gerais para o agente';

  @override
  String get mathFormatting => 'Formatação matemática';

  @override
  String get mathFormattingHelper => 'Instruções para saída LaTeX';

  @override
  String get generatorRole => 'Papel do Gerador';

  @override
  String get generatorRoleHelper => 'Prompt para criar o primeiro rascunho';

  @override
  String get criticRole => 'Papel do Crítico (Padrão)';

  @override
  String get criticRoleHelper => 'Prompt para auto-revisão padrão';

  @override
  String get devilsAdvocateRole => 'Papel de Advogado do Diabo';

  @override
  String get devilsAdvocateRoleHelper => 'Prompt para crítica agressiva';

  @override
  String get editorRole => 'Papel do Editor';

  @override
  String get editorRoleHelper => 'Prompt para a fase final de polimento';

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
}
