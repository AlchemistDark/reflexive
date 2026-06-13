// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Agente Reflexivo';

  @override
  String get settings => 'Ajustes';

  @override
  String get general => 'General';

  @override
  String get prompts => 'Prompts';

  @override
  String iteration(int count) {
    return 'Iteración: $count';
  }

  @override
  String remaining(int seconds) {
    return 'Restante: ${seconds}s';
  }

  @override
  String get critic => 'Crítico:';

  @override
  String get generatorDraft => 'Generador (Borrador):';

  @override
  String get stoppingCriteria => 'Criterios de parada';

  @override
  String get maxDuration => 'Duración máxima (segundos)';

  @override
  String get maxIterations => 'Máximas iteraciones';

  @override
  String get requestDelay => 'Retraso de solicitud (ms)';

  @override
  String get requestDelaySubtitle =>
      'Retraso entre llamadas API para evitar límites de tasa';

  @override
  String get stopIfNoIssues => 'Detener si no hay problemas';

  @override
  String get stopIfNoIssuesSubtitle =>
      'Salir temprano si el Crítico no encuentra fallos';

  @override
  String get reflectionStrategy => 'Estrategia de reflexión';

  @override
  String get llmConfiguration => 'Configuración de LLM';

  @override
  String get provider => 'Proveedor';

  @override
  String get apiKey => 'Clave API';

  @override
  String get baseUrl => 'URL base';

  @override
  String get modelName => 'Nombre del modelo';

  @override
  String get modelNameHelper =>
      'Escriba \"auto\" o \"default\" para usar el modelo recomendado';

  @override
  String get resetToDefault => 'Restablecer';

  @override
  String get resetToProviderDefault => 'Restablecer a valores del proveedor';

  @override
  String get systemArchitecture => 'Arquitectura del sistema';

  @override
  String get systemArchitectureHelper =>
      'Instrucciones generales para el agente';

  @override
  String get mathFormatting => 'Formato matemático';

  @override
  String get mathFormattingHelper => 'Instrucciones para salida LaTeX';

  @override
  String get generatorRole => 'Rol del Generador';

  @override
  String get generatorRoleHelper => 'Prompt para crear el primer borrador';

  @override
  String get criticRole => 'Rol del Crítico (Estándar)';

  @override
  String get criticRoleHelper => 'Prompt para revisión estándar';

  @override
  String get devilsAdvocateRole => 'Rol de Abogado del Diablo';

  @override
  String get devilsAdvocateRoleHelper => 'Prompt para crítica agresiva';

  @override
  String get editorRole => 'Rol del Editor';

  @override
  String get editorRoleHelper => 'Prompt para la etapa final de pulido';

  @override
  String get exportPrompts => 'Exportar prompts';

  @override
  String get importPrompts => 'Importar prompts';

  @override
  String get exportSuccess => 'Prompts exportados al portapapeles';

  @override
  String get importSuccess => 'Prompts importados con éxito';

  @override
  String get importError => 'Error al importar prompts: Formato no válido';
}
