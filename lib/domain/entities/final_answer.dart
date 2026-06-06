import 'package:reflexive/domain/entities/internal_step.dart';
import 'package:reflexive/domain/entities/stopped_reason.dart';

/// Represents the final result of the reflection process.
class FinalAnswer {
  /// The final polished text content of the answer.
  final String text;

  /// The list of all intermediate steps taken by the agents.
  final List<InternalStep> internalSteps;

  /// The total time taken to generate and reflect on the answer.
  final Duration totalTime;

  /// The number of reflection iterations performed.
  final int iterationsUsed;

  /// The reason why the reflection process stopped.
  final StoppedReason stoppedReason;

  FinalAnswer({
    required this.text,
    required this.internalSteps,
    required this.totalTime,
    required this.iterationsUsed,
    required this.stoppedReason,
  });
}
