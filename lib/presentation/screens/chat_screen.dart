import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/agent_role.dart';
import '../../domain/entities/time_preset.dart';
import '../../domain/entities/final_answer.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'settings_screen.dart';
import '../../core/di/injection_container.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  TimePreset _selectedPreset = TimePreset.normal;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage(BuildContext context) {
    if (_controller.text.trim().isEmpty) return;
    context.read<ChatBloc>().add(
          SendUserMessage(_controller.text.trim(), _selectedPreset),
        );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChatBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reflexive Agent'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            PopupMenuButton<TimePreset>(
              initialValue: _selectedPreset,
              onSelected: (preset) {
                setState(() => _selectedPreset = preset);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: TimePreset.fast, child: Text('Быстрый')),
                const PopupMenuItem(value: TimePreset.normal, child: Text('Обычный')),
                const PopupMenuItem(value: TimePreset.deep, child: Text('Глубокий')),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(child: Text(_selectedPreset.name)),
              ),
            ),
          ],
        ),
        body: Builder(builder: (context) {
          return Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatInitial) {
                      return const Center(child: Text('Введите ваш запрос'));
                    }
                    if (state is ChatReflecting) {
                      return _ReflectionView(state: state);
                    }
                    if (state is ChatResponseReady) {
                      return _ResponseView(answer: state.answer);
                    }
                    if (state is ChatError) {
                      return Center(
                        child: Text(
                          'Ошибка: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              _buildInputArea(context),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final isReflecting = state is ChatReflecting;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: !isReflecting,
                  decoration: const InputDecoration(
                    hintText: 'Задайте вопрос...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _sendMessage(context),
                ),
              ),
              const SizedBox(width: 8),
              isReflecting
                  ? IconButton(
                      icon: const Icon(Icons.stop, color: Colors.red),
                      onPressed: () {
                        context.read<ChatBloc>().add(const CancelReflection());
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _sendMessage(context),
                    ),
            ],
          ),
        );
      },
    );
  }
}

class _ReflectionView extends StatelessWidget {
  final ChatReflecting state;

  const _ReflectionView({required this.state});

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
              Text('Итерация: ${state.currentIteration}'),
              Text('Осталось: ${state.remainingTime.inSeconds}с'),
            ],
          ),
          const Divider(),
          if (state.lastUpdate != null) ...[
            Text(
              state.lastRole == AgentRole.critic ? 'Критик:' : 'Генератор (черновик):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: MarkdownBody(data: state.lastUpdate!),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResponseView extends StatelessWidget {
  final FinalAnswer answer;

  const _ResponseView({required this.answer});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Финальный ответ:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          MarkdownBody(
            data: answer.text,
            selectable: true,
          ),
          const SizedBox(height: 24),
          ExpansionTile(
            title: const Text('Процесс рефлексии (логи)'),
            children: answer.internalSteps.map<Widget>((step) {
              return ExpansionTile(
                title: Text(step.role == AgentRole.critic ? 'Критика ${step.iteration}' : 'Улучшение ${step.iteration}'),
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
            'Всего итераций: ${answer.iterationsUsed}, Время: ${answer.totalTime.inSeconds}с',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            'Причина остановки: ${answer.stoppedReason.name}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
