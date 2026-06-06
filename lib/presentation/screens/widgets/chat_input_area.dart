import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reflexive/presentation/bloc/chat_bloc.dart';
import 'package:reflexive/presentation/bloc/chat_event.dart';
import 'package:reflexive/presentation/bloc/chat_state.dart';

/// A widget that provides the input field and action buttons for the chat.
class ChatInputArea extends StatelessWidget {
  /// Controller for the text field.
  final TextEditingController controller;

  /// Callback triggered when the user wants to send a message.
  final VoidCallback onSend;

  const ChatInputArea({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final isReflecting = state is ChatReflecting;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !isReflecting,
                  decoration: const InputDecoration(
                    hintText: 'Ask a question...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => isReflecting ? null : onSend(),
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
                      onPressed: onSend,
                    ),
            ],
          ),
        );
      },
    );
  }
}
