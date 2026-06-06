import 'internal_step.dart';
import 'stopped_reason.dart';

class FinalAnswer {
  final String text;
  final List<InternalStep> internalSteps;
  final Duration totalTime;
  final int iterationsUsed;
  final StoppedReason stoppedReason;

  FinalAnswer({
    required this.text,
    required this.internalSteps,
    required this.totalTime,
    required this.iterationsUsed,
    required this.stoppedReason,
  });
}
