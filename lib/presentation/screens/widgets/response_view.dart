import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:reflexive/domain/entities/agent_role.dart';
import 'package:reflexive/domain/entities/final_answer.dart';

/// A widget that displays the final answer and the reflection logs.
class ResponseView extends StatelessWidget {
  /// The final answer produced by the agent.
  final FinalAnswer answer;

  const ResponseView({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Final Answer:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          MarkdownBody(
            data: answer.text,
            selectable: true,
          ),
          const SizedBox(height: 24),
          ExpansionTile(
            title: const Text('Reflection Process (Logs)'),
            children: answer.internalSteps.map<Widget>((step) {
              return ExpansionTile(
                title: Text(step.role == AgentRole.critic ? 'Critique ${step.iteration}' : 'Improvement ${step.iteration}'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MarkdownBody(data: step.content),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Total iterations: ${answer.iterationsUsed}, Time: ${answer.totalTime.inSeconds}s',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            'Stopped reason: ${answer.stoppedReason.name}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
