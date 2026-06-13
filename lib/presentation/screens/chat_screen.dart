import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reflexive/presentation/bloc/chat_bloc.dart';
import 'package:reflexive/presentation/bloc/chat_event.dart';
import 'package:reflexive/presentation/bloc/chat_state.dart';
import 'package:reflexive/presentation/screens/settings_screen.dart';
import 'package:reflexive/core/di/injection_container.dart';
import 'package:reflexive/presentation/screens/widgets/chat_input_area.dart';
import 'package:reflexive/presentation/screens/widgets/reflection_view.dart';
import 'package:reflexive/presentation/screens/widgets/response_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// The main chat screen where users interact with the Reflexive Agent.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Sends the user message to the BLoC to start the reflection process.
  void _sendMessage(BuildContext context) {
    if (_controller.text.trim().isEmpty) return;
    context.read<ChatBloc>().add(
          SendUserMessage(_controller.text.trim()),
        );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => sl<ChatBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: Builder(builder: (context) {
          return Column(
            children: [
              Expanded(
                child: SelectionArea(
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatInitial) {
                        return Center(child: Text(l10n.appTitle));
                      }
                      if (state is ChatReflecting) {
                        return ReflectionView(state: state);
                      }
                      if (state is ChatResponseReady) {
                        return ResponseView(answer: state.answer);
                      }
                      if (state is ChatError) {
                        return Center(
                          child: Text(
                            'Error: ${state.message}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              ChatInputArea(
                controller: _controller,
                onSend: () => _sendMessage(context),
              ),
            ],
          );
        }),
      ),
    );
  }
}
