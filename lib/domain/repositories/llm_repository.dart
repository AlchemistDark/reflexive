import '../entities/chat_message.dart';

abstract class LlmRepository {
  Future<String> generate({
    required String systemPrompt,
    required List<ChatMessage> messages,
    Object? cancelToken, // Используем Object для сохранения чистоты Domain, либо конкретный тип если проект это допускает
  });
}
