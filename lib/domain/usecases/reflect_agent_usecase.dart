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

  /// Instruction for consistent LaTeX formatting.
  static const _mathPrompt =
      " IMPORTANT: Use LaTeX for all mathematical formulas. Use \\( ... \\) for inline math and \\[ ... \\] for block math.";

  /// System context to explain the architecture to the LLM.
  static const _systemArchitecture =
      "You are the central intelligence of the 'Reflexive Agent'. You perform a multi-role reflection process where you sequentially act as Generator, Critic, and Editor. "
      "Your goal is self-improvement through iterative analysis. You are responsible for both creating the content and identifying your own mistakes to ensure the final output is flawless. "
      "The process follows these stages: GENERATION -> CRITIQUE -> IMPROVEMENT. ";

  /// Instruction to encourage internet search usage.
  static const _internetPrompt =
      " You have access to internet search tools. Use them proactively to verify facts, cite sources, and ensure your information is up-to-date.";

  ReflectAgentUseCase({required this.llmRepository});

  /// Executes the reflection loop for a given [query].
  ///
  /// Returns a [Stream] of [ReflectionStep] containing intermediate results.
  /// [timePreset] defines the constraints (duration and iterations).
  /// [mode] defines the strategy used by the Critic agent.
  /// [stopOnNoIssues] if true, the process stops when the Critic returns "NO_ISSUES".
  /// [delay] duration to wait between API calls.
  /// [cancelToken] can be used to abort the process.
  Stream<ReflectionStep> execute({
    required String query,
    required TimePreset timePreset,
    ReflectionMode mode = ReflectionMode.standard,
    bool stopOnNoIssues = true,
    Duration delay = Duration.zero,
    Object? cancelToken,
    String? systemArchitecture,
    String? mathPrompt,
    String? generatorPrompt,
    String? criticPrompt,
    String? devilsAdvocatePrompt,
    String? editorPrompt,
    bool useInternet = false,
  }) async* {
    final stopwatch = Stopwatch()..start();
    final timeBudget = timePreset.maxDuration.inMilliseconds;

    String architecture = systemArchitecture ?? _systemArchitecture;
    if (useInternet) {
      architecture += _internetPrompt;
    }
    final math = mathPrompt ?? _mathPrompt;

    // 1. Initial generation
    String currentAnswer = await llmRepository.generate(
      systemPrompt:
          "$architecture\n"
          "${generatorPrompt ?? "Current Role: GENERATOR. Create the first comprehensive draft of the answer. Since you will later critique this draft yourself, try to make it as solid as possible from the start."}$math",
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

      // Apply delay before next API call
      if (delay > Duration.zero) {
        await Future.delayed(delay);
      }

      // 2. Critique (depending on the mode)
      final String criticSystemPrompt;
      if (mode == ReflectionMode.devilsAdvocate) {
        criticSystemPrompt =
            "$architecture\n"
            "${devilsAdvocatePrompt ?? "Current Role: CRITIC (Devil's Advocate). Now, objectively analyze YOUR OWN previous draft. Search for hidden flaws, weak logic, and assumptions you might have missed. Be brutally honest with yourself. Output your self-critique as a list. If perfect, output: NO_ISSUES."}$math";
      } else {
        criticSystemPrompt =
            "$architecture\n"
            "${criticPrompt ?? "Current Role: CRITIC (Self-Review). Review your own previous draft for accuracy, clarity, and completeness. Identify what YOU can do better. Output a list of improvements. If no changes are needed, output only: NO_ISSUES."}$math";
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
        systemPrompt:
            "$architecture\n"
            "${editorPrompt ?? "Current Role: EDITOR. This is the final stage of your reflection. Combine your original draft and your own critique to produce a perfect, polished version. Output ONLY the final answer content. Do not talk to the user about the process."}$math",
        messages: [
          ChatMessage(role: "user", content: "Original Query: $query"),
          ChatMessage(role: "assistant", content: "Your Previous Draft: $currentAnswer"),
          ChatMessage(role: "user", content: "Your Own Critique: $critique"),
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
