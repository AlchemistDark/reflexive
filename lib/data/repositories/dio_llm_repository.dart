import 'package:dio/dio.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/llm_repository.dart';

class DioLlmRepository implements LlmRepository {
  final Dio _dio;
  final String _apiKey;
  final String _baseUrl;
  final String _model;

  DioLlmRepository({
    required Dio dio,
    required String apiKey,
    String baseUrl = 'https://api.deepseek.com/v1',
    String model = 'deepseek-chat',
  })  : _dio = dio,
        _apiKey = apiKey,
        _baseUrl = baseUrl,
        _model = model;

  @override
  Future<String> generate({
    required String systemPrompt,
    required List<ChatMessage> messages,
    Object? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            ...messages.map((m) => {'role': m.role, 'content': m.content}),
          ],
          'temperature': 0.7,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
        cancelToken: cancelToken as CancelToken?,
      );

      return response.data['choices'][0]['message']['content'] as String;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw Exception('Запрос отменен пользователем');
      }
      throw Exception('Ошибка API: ${e.message}');
    } catch (e) {
      throw Exception('Непредвиденная ошибка: $e');
    }
  }
}
