import 'agent_role.dart';

class InternalStep {
  final AgentRole role;
  final String content;
  final DateTime timestamp;
  final int iteration;

  InternalStep({
    required this.role,
    required this.content,
    required this.timestamp,
    required this.iteration,
  });
}
