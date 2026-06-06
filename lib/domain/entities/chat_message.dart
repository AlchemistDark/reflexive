/// Represents a single message in a chat conversation.
class ChatMessage {
  /// The role of the message sender (e.g., 'user', 'assistant', 'system').
  final String role;

  /// The text content of the message.
  final String content;

  ChatMessage({
    required this.role,
    required this.content,
  });
}
