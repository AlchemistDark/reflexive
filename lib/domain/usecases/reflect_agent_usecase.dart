import '../entities/agent_role.dart';
import '../entities/chat_message.dart';
import '../entities/reflection_mode.dart';
import '../entities/reflection_step.dart';
import '../entities/time_preset.dart';
import '../repositories/llm_repository.dart';

class ReflectAgentUseCase {
  final LlmRepository llmRepository;

  ReflectAgentUseCase({required this.llmRepository});

  Stream<ReflectionStep> execute({
    required String query,
    required TimePreset timePreset,
    ReflectionMode mode = ReflectionMode.standard,
    Object? cancelToken,
  }) async* {
    final stopwatch = Stopwatch()..start();
    final timeBudget = timePreset.maxDuration.inMilliseconds;

    // 1. Первая генерация
    String currentAnswer = await llmRepository.generate(
      systemPrompt: "Ты полезный ассистент. Дай точный и развернутый ответ на вопрос пользователя.",
      messages: [ChatMessage(role: "user", content: query)],
      cancelToken: cancelToken,
    );

    yield ReflectionStep(
      iteration: 0,
      remaining: _getRemaining(stopwatch, timeBudget),
      content: currentAnswer,
      role: AgentRole.generator,
    );

    int iteration = 0;

    while (stopwatch.elapsedMilliseconds < timeBudget) {
      iteration++;
      if (iteration > timePreset.maxIterations) break;

      // 2. Критика (в зависимости от режима)
      final String criticSystemPrompt;
      if (mode == ReflectionMode.devilsAdvocate) {
        criticSystemPrompt = "Ты — 'Адвокат дьявола'. Твоя задача — найти 3 самых слабых места в текущем ответе, "
            "выявить логические пробелы и поставить под сомнение аргументацию. "
            "Будь строгим, но конструктивным. Если ответ безупречен, напиши только: NO_ISSUES";
      } else {
        criticSystemPrompt = "Проанализируй текущий ответ на вопрос. Найди логические ошибки, фактические неточности или способы сделать ответ лучше. "
            "Если ответ не требует правок и полностью раскрывает тему, напиши только одно слово: NO_ISSUES";
      }

      final critique = await llmRepository.generate(
        systemPrompt: criticSystemPrompt,
        messages: [
          ChatMessage(
            role: "user",
            content: "Вопрос пользователя: $query\nТекущий ответ: $currentAnswer",
          )
        ],
        cancelToken: cancelToken,
      );

      yield ReflectionStep(
        iteration: iteration,
        remaining: _getRemaining(stopwatch, timeBudget),
        content: critique,
        role: AgentRole.critic,
      );

      if (critique.trim().toUpperCase().contains("NO_ISSUES")) break;

      // 3. Генерация исправленного ответа
      final improved = await llmRepository.generate(
        systemPrompt: "Исправь и улучши ответ на основе полученной критики.",
        messages: [
          ChatMessage(role: "user", content: query),
          ChatMessage(role: "assistant", content: currentAnswer),
          ChatMessage(role: "user", content: "Критика: $critique"),
        ],
        cancelToken: cancelToken,
      );

      if (improved.trim() == currentAnswer.trim()) break;

      currentAnswer = improved;

      yield ReflectionStep(
        iteration: iteration,
        remaining: _getRemaining(stopwatch, timeBudget),
        content: improved,
        role: AgentRole.generator,
      );
    }
  }

  Duration _getRemaining(Stopwatch sw, int budgetMs) {
    final remaining = budgetMs - sw.elapsedMilliseconds;
    return Duration(milliseconds: remaining > 0 ? remaining : 0);
  }
}
