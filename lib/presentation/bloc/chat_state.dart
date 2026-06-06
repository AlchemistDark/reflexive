import 'package:equatable/equatable.dart';
import '../../domain/entities/agent_role.dart';
import '../../domain/entities/final_answer.dart';
import '../../domain/entities/internal_step.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatReflecting extends ChatState {
  final int currentIteration;
  final Duration remainingTime;
  final String? lastUpdate;
  final AgentRole? lastRole;
  final List<InternalStep> steps;

  const ChatReflecting({
    required this.currentIteration,
    required this.remainingTime,
    this.lastUpdate,
    this.lastRole,
    required this.steps,
  });

  ChatReflecting copyWith({
    int? currentIteration,
    Duration? remainingTime,
    String? lastUpdate,
    AgentRole? lastRole,
    List<InternalStep>? steps,
  }) {
    return ChatReflecting(
      currentIteration: currentIteration ?? this.currentIteration,
      remainingTime: remainingTime ?? this.remainingTime,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      lastRole: lastRole ?? this.lastRole,
      steps: steps ?? this.steps,
    );
  }

  @override
  List<Object?> get props => [
        currentIteration,
        remainingTime,
        lastUpdate,
        lastRole,
        steps,
      ];
}

class ChatResponseReady extends ChatState {
  final FinalAnswer answer;

  const ChatResponseReady(this.answer);

  @override
  List<Object?> get props => [answer];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
