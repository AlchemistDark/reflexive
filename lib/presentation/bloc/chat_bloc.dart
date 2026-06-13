import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reflexive/domain/entities/agent_role.dart';
import 'package:reflexive/domain/entities/final_answer.dart';
import 'package:reflexive/domain/entities/internal_step.dart';
import 'package:reflexive/domain/entities/reflection_step.dart';
import 'package:reflexive/domain/entities/stopped_reason.dart';
import 'package:reflexive/domain/usecases/reflect_agent_usecase.dart';
import 'package:reflexive/domain/repositories/settings_repository.dart';
import 'package:reflexive/domain/entities/time_preset.dart';
import 'package:reflexive/presentation/bloc/chat_event.dart';
import 'package:reflexive/presentation/bloc/chat_state.dart';

/// BLoC that manages the chat state and reflection process.
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ReflectAgentUseCase _reflectAgentUseCase;
  final SettingsRepository _settingsRepository;
  CancelToken? _cancelToken;

  ChatBloc({
    required ReflectAgentUseCase reflectAgentUseCase,
    required SettingsRepository settingsRepository,
  })  : _reflectAgentUseCase = reflectAgentUseCase,
        _settingsRepository = settingsRepository,
        super(ChatInitial()) {
    on<SendUserMessage>(_onSendUserMessage);
    on<CancelReflection>(_onCancelReflection);
  }

  /// Handles the [SendUserMessage] event to start the reflection loop.
  Future<void> _onSendUserMessage(
    SendUserMessage event,
    Emitter<ChatState> emit,
  ) async {
    _cancelToken = CancelToken();
    final steps = <InternalStep>[];
    final stopwatch = Stopwatch()..start();

    // Read settings from the repository
    final maxDurationSeconds = _settingsRepository.getMaxDuration();
    final maxIterations = _settingsRepository.getMaxIterations();
    final stopOnNoIssues = _settingsRepository.getStopOnNoIssues();
    final reflectionMode = _settingsRepository.getReflectionMode();
    final requestDelayMs = _settingsRepository.getRequestDelay();

    // Fetch custom prompts
    final systemArchitecture = _settingsRepository.getSystemArchitecturePrompt();
    final mathPrompt = _settingsRepository.getMathPrompt();
    final generatorPrompt = _settingsRepository.getGeneratorPrompt();
    final criticPrompt = _settingsRepository.getCriticPrompt();
    final devilsAdvocatePrompt = _settingsRepository.getDevilsAdvocatePrompt();
    final editorPrompt = _settingsRepository.getEditorPrompt();
    final useInternet = _settingsRepository.getUseInternet();

    // Create a custom preset based on user settings
    final effectivePreset = TimePreset(
      name: "Custom",
      maxDuration: Duration(seconds: maxDurationSeconds),
      maxIterations: maxIterations,
    );

    emit(ChatReflecting(
      currentIteration: 0,
      remainingTime: effectivePreset.maxDuration,
      steps: const [],
    ));

    try {
      await emit.forEach<ReflectionStep>(
        _reflectAgentUseCase.execute(
          query: event.text,
          timePreset: effectivePreset,
          mode: reflectionMode,
          stopOnNoIssues: stopOnNoIssues,
          delay: Duration(milliseconds: requestDelayMs),
          cancelToken: _cancelToken,
          systemArchitecture: systemArchitecture,
          mathPrompt: mathPrompt,
          generatorPrompt: generatorPrompt,
          criticPrompt: criticPrompt,
          devilsAdvocatePrompt: devilsAdvocatePrompt,
          editorPrompt: editorPrompt,
          useInternet: useInternet,
        ),
        onData: (step) {
          final internalStep = InternalStep(
            role: step.role,
            content: step.content,
            timestamp: DateTime.now(),
            iteration: step.iteration,
          );
          steps.add(internalStep);

          return (state as ChatReflecting).copyWith(
            currentIteration: step.iteration,
            remainingTime: step.remaining,
            lastUpdate: step.content,
            lastRole: step.role,
            steps: List.from(steps),
          );
        },
        onError: (error, stackTrace) {
          return ChatError(error.toString());
        },
      );

      // After the stream completes (if no error occurred)
      if (state is ChatReflecting) {
        final reflectingState = state as ChatReflecting;
        
        // Determine the stop reason
        StoppedReason reason = StoppedReason.noImprovement;
        if (_cancelToken?.isCancelled == true) {
          reason = StoppedReason.userCancelled;
        } else if (reflectingState.remainingTime <= Duration.zero) {
          reason = StoppedReason.timeout;
        } else if (reflectingState.lastUpdate?.contains('NO_ISSUES') == true) {
          reason = StoppedReason.noIssues;
        } else if (reflectingState.currentIteration >= maxIterations) {
          reason = StoppedReason.maxIterations;
        }

        // Find the best answer (the last one from the generator)
        String finalContent = "";
        for (var i = steps.length - 1; i >= 0; i--) {
          if (steps[i].role == AgentRole.generator) {
            finalContent = steps[i].content;
            break;
          }
        }

        emit(ChatResponseReady(
          FinalAnswer(
            text: finalContent,
            internalSteps: steps,
            totalTime: stopwatch.elapsed,
            iterationsUsed: reflectingState.currentIteration,
            stoppedReason: reason,
          ),
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(ChatError(e.toString()));
      }
    } finally {
      stopwatch.stop();
      _cancelToken = null;
    }
  }

  /// Handles the [CancelReflection] event to abort the current process.
  void _onCancelReflection(CancelReflection event, Emitter<ChatState> emit) {
    _cancelToken?.cancel();
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
}
