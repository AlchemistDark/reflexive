import 'package:reflexive/domain/entities/agent_role.dart';

/// Represents a single internal step within the reflection process log.
class InternalStep {
  /// The role of the agent that performed this step.
  final AgentRole role;

  /// The content generated during this step.
  final String content;

  /// The time when this step was completed.
  final DateTime timestamp;

  /// The iteration number this step belongs to.
  final int iteration;

  InternalStep({
    required this.role,
    required this.content,
    required this.timestamp,
    required this.iteration,
  });
}
