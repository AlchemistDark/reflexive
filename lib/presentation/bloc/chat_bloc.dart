import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/agent_role.dart';
import '../../domain/entities/final_answer.dart';
import '../../domain/entities/internal_step.dart';
import '../../domain/entities/reflection_step.dart';
import '../../domain/entities/stopped_reason.dart';
import '../../domain/usecases/reflect_agent_usecase.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/entities/time_preset.dart';
import 'chat_event.dart';
import 'chat_state.dart';

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

  Future<void> _onSendUserMessage(
    SendUserMessage event,
    Emitter<ChatState> emit,
  ) async {
    _cancelToken = CancelToken();
    final steps = <InternalStep>[];
    final stopwatch = Stopwatch()..start();

    // Читаем настройки из репозитория
    final maxDurationSeconds = _settingsRepository.getMaxDuration();
    final reflectionMode = _settingsRepository.getReflectionMode();

    // Создаем кастомный пресет на основе настроек
    final effectivePreset = TimePreset(
      name: "Настраиваемый",
      maxDuration: Duration(seconds: maxDurationSeconds),
      maxIterations: event.timePreset.maxIterations, // Или тоже вынести в настройки
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
          cancelToken: _cancelToken,
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

      // После завершения стрима (если не было ошибки)
      if (state is ChatReflecting) {
        final reflectingState = state as ChatReflecting;
        
        // Определяем причину остановки
        StoppedReason reason = StoppedReason.noImprovement;
        if (_cancelToken?.isCancelled == true) {
          reason = StoppedReason.userCancelled;
        } else if (reflectingState.remainingTime <= Duration.zero) {
          reason = StoppedReason.timeout;
        } else if (reflectingState.lastUpdate?.contains('NO_ISSUES') == true) {
          reason = StoppedReason.noIssues;
        } else if (reflectingState.currentIteration >= event.timePreset.maxIterations) {
          reason = StoppedReason.maxIterations;
        }

        // Находим лучший ответ (последний от генератора)
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

  void _onCancelReflection(CancelReflection event, Emitter<ChatState> emit) {
    _cancelToken?.cancel();
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
}
