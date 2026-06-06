import 'agent_role.dart';

class ReflectionStep {
  final int iteration;
  final Duration remaining;
  final String content;
  final AgentRole role;

  ReflectionStep({
    required this.iteration,
    required this.remaining,
    required this.content,
    required this.role,
  });
}
