import 'package:reflexive/domain/entities/agent_role.dart';

/// Represents a single update emitted during the reflection stream.
class ReflectionStep {
  /// The current iteration number.
  final int iteration;

  /// The approximate remaining time for the reflection process.
  final Duration remaining;

  /// The content generated in this specific step.
  final String content;

  /// The role of the agent that produced this content.
  final AgentRole role;

  ReflectionStep({
    required this.iteration,
    required this.remaining,
    required this.content,
    required this.role,
  });
}
