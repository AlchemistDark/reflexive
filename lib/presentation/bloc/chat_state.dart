import 'package:equatable/equatable.dart';
import 'package:reflexive/domain/entities/agent_role.dart';
import 'package:reflexive/domain/entities/final_answer.dart';
import 'package:reflexive/domain/entities/internal_step.dart';

/// Base class for all states in the [ChatBloc].
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any message is sent.
class ChatInitial extends ChatState {}

/// State during the reflection process, emitting live updates.
class ChatReflecting extends ChatState {
  /// The current iteration index (0 for initial, 1+ for reflection).
  final int currentIteration;

  /// The estimated time remaining for the process.
  final Duration remainingTime;

  /// The latest content received from either the Generator or Critic.
  final String? lastUpdate;

  /// The role of the agent that produced the [lastUpdate].
  final AgentRole? lastRole;

  /// The list of all steps completed so far.
  final List<InternalStep> steps;

  const ChatReflecting({
    required this.currentIteration,
    required this.remainingTime,
    this.lastUpdate,
    this.lastRole,
    required this.steps,
  });

  /// Creates a copy of this state with updated fields.
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

/// State indicating the reflection is complete and the final answer is ready.
class ChatResponseReady extends ChatState {
  /// The final answer including all internal logs and meta-data.
  final FinalAnswer answer;

  const ChatResponseReady(this.answer);

  @override
  List<Object?> get props => [answer];
}

/// State representing an error that occurred during the process.
class ChatError extends ChatState {
  /// The error message.
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
