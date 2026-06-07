import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:reflexive/domain/entities/agent_role.dart';
import 'package:reflexive/presentation/bloc/chat_state.dart';
import 'package:reflexive/presentation/screens/widgets/code_highlighter_builder.dart';
import 'package:reflexive/presentation/screens/widgets/math_builder.dart';

/// A widget that displays the ongoing reflection process.
class ReflectionView extends StatelessWidget {
  /// The current state of the reflection.
  final ChatReflecting state;

  const ReflectionView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: state.currentIteration > 0 ? null : 0,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Iteration: ${state.currentIteration}'),
              Text('Remaining: ${state.remainingTime.inSeconds}s'),
            ],
          ),
          const Divider(),
          if (state.lastUpdate != null) ...[
            Text(
              state.lastRole == AgentRole.critic ? 'Critic:' : 'Generator (Draft):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: MarkdownBody(
                data: state.lastUpdate!,
                builders: {
                  'code': CodeHighlighterBuilder(),
                  'latex': MathBuilder(),
                },
                inlineSyntaxes: LaTeXSettings.inlineSyntaxes,
                blockSyntaxes: LaTeXSettings.blockSyntaxes,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
