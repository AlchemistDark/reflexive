import 'package:reflexive/domain/entities/chat_message.dart';

/// Abstract interface for Large Language Model (LLM) interaction.
abstract class LlmRepository {
  /// Generates a response from the LLM based on the provided [systemPrompt] and [messages].
  ///
  /// [cancelToken] can be used to abort the request.
  Future<String> generate({
    required String systemPrompt,
    required List<ChatMessage> messages,
    Object? cancelToken,
  });
}
