import 'package:reflexive/domain/entities/agent_role.dart';
import 'package:reflexive/domain/entities/chat_message.dart';
import 'package:reflexive/domain/entities/reflection_mode.dart';
import 'package:reflexive/domain/entities/reflection_step.dart';
import 'package:reflexive/domain/entities/time_preset.dart';
import 'package:reflexive/domain/repositories/llm_repository.dart';

/// Use case that implements the iterative reflection loop (Generator/Critic roles).
class ReflectAgentUseCase {
  /// The repository used to interact with the Language Model.
  final LlmRepository llmRepository;

  ReflectAgentUseCase({required this.llmRepository});

  /// Executes the reflection loop for a given [query].
  ///
  /// Returns a [Stream] of [ReflectionStep] containing intermediate results.
  /// [timePreset] defines the constraints (duration and iterations).
  /// [mode] defines the strategy used by the Critic agent.
  /// [stopOnNoIssues] if true, the process stops when the Critic returns "NO_ISSUES".
  /// [cancelToken] can be used to abort the process.
  Stream<ReflectionStep> execute({
    required String query,
    required TimePreset timePreset,
    ReflectionMode mode = ReflectionMode.standard,
    bool stopOnNoIssues = true,
    Object? cancelToken,
  }) async* {
    final stopwatch = Stopwatch()..start();
    final timeBudget = timePreset.maxDuration.inMilliseconds;

    // 1. Initial generation
    String currentAnswer = await llmRepository.generate(
      systemPrompt: "You are a helpful assistant. Provide an accurate and detailed answer to the user's question.",
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

      // 2. Critique (depending on the mode)
      final String criticSystemPrompt;
      if (mode == ReflectionMode.devilsAdvocate) {
        criticSystemPrompt = "You are a 'Devil's Advocate'. Your task is to find the 3 weakest points in the current response, "
            "identify logical gaps, and question the argumentation. "
            "Be strict but constructive. If the response is flawless, write only: NO_ISSUES";
      } else {
        criticSystemPrompt = "Analyze the current answer to the question. Find logical errors, factual inaccuracies, or ways to make the answer better. "
            "If the answer requires no changes and fully covers the topic, write only one word: NO_ISSUES";
      }

      final critique = await llmRepository.generate(
        systemPrompt: criticSystemPrompt,
        messages: [
          ChatMessage(
            role: "user",
            content: "User question: $query\nCurrent answer: $currentAnswer",
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

      if (stopOnNoIssues && critique.trim().toUpperCase().contains("NO_ISSUES")) break;

      // 3. Generation of improved answer
      final improved = await llmRepository.generate(
        systemPrompt: "Correct and improve the answer based on the received critique.",
        messages: [
          ChatMessage(role: "user", content: query),
          ChatMessage(role: "assistant", content: currentAnswer),
          ChatMessage(role: "user", content: "Critique: $critique"),
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

  /// Calculates the remaining duration based on the budget and elapsed time.
  Duration _getRemaining(Stopwatch sw, int budgetMs) {
    final remaining = budgetMs - sw.elapsedMilliseconds;
    return Duration(milliseconds: remaining > 0 ? remaining : 0);
  }
}
