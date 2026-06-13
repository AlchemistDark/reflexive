// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Рефлексивный Агент';

  @override
  String get settings => 'Настройки';

  @override
  String get general => 'Общие';

  @override
  String get prompts => 'Промпты';

  @override
  String iteration(int count) {
    return 'Итерация: $count';
  }

  @override
  String remaining(int seconds) {
    return 'Осталось: $seconds сек';
  }

  @override
  String get critic => 'Критик:';

  @override
  String get generatorDraft => 'Генератор (Черновик):';

  @override
  String get stoppingCriteria => 'Критерии остановки';

  @override
  String get maxDuration => 'Макс. длительность (сек)';

  @override
  String get maxIterations => 'Макс. итераций';

  @override
  String get requestDelay => 'Задержка запроса (мс)';

  @override
  String get requestDelaySubtitle =>
      'Задержка между вызовами API для обхода лимитов';

  @override
  String get stopIfNoIssues => 'Стоп, если нет замечаний';

  @override
  String get stopIfNoIssuesSubtitle =>
      'Ранний выход, если Критик не нашел изъянов';

  @override
  String get reflectionStrategy => 'Стратегия рефлексии';

  @override
  String get llmConfiguration => 'Конфигурация LLM';

  @override
  String get provider => 'Провайдер';

  @override
  String get apiKey => 'API ключ';

  @override
  String get baseUrl => 'Базовый URL';

  @override
  String get modelName => 'Имя модели';

  @override
  String get modelNameHelper =>
      'Введите \"auto\" или \"default\" для выбора рекомендуемой модели';

  @override
  String get resetToDefault => 'Сбросить';

  @override
  String get resetToProviderDefault => 'Сбросить на настройки провайдера';

  @override
  String get systemArchitecture => 'Архитектура системы';

  @override
  String get systemArchitectureHelper => 'Общие инструкции для агента';

  @override
  String get mathFormatting => 'Форматирование математики';

  @override
  String get mathFormattingHelper => 'Инструкции для вывода LaTeX';

  @override
  String get generatorRole => 'Роль Генератора';

  @override
  String get generatorRoleHelper => 'Промпт для создания первого черновика';

  @override
  String get criticRole => 'Роль Критика (Стандарт)';

  @override
  String get criticRoleHelper => 'Промпт для стандартного самоанализа';

  @override
  String get devilsAdvocateRole => 'Роль Адвоката Дьявола';

  @override
  String get devilsAdvocateRoleHelper => 'Промпт для агрессивной критики';

  @override
  String get editorRole => 'Роль Редактора';

  @override
  String get editorRoleHelper => 'Промпт для финальной шлифовки ответа';

  @override
  String get exportPrompts => 'Экспорт промптов';

  @override
  String get importPrompts => 'Импорт промптов';

  @override
  String get exportSuccess => 'Промпты скопированы в буфер обмена';

  @override
  String get importSuccess => 'Промпты успешно импортированы';

  @override
  String get importError => 'Ошибка импорта: Неверный формат';
}
