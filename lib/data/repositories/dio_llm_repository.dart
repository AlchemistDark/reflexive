import 'package:dio/dio.dart';
import 'package:reflexive/domain/entities/chat_message.dart';
import 'package:reflexive/domain/repositories/llm_repository.dart';
import 'package:reflexive/domain/repositories/settings_repository.dart';

/// Implementation of [LlmRepository] using the Dio HTTP client.
class DioLlmRepository implements LlmRepository {
  final Dio _dio;
  final SettingsRepository _settingsRepository;

  /// Creates a new instance of [DioLlmRepository].
  ///
  /// [_dio] is the HTTP client.
  /// [_settingsRepository] is used to retrieve current API configuration.
  DioLlmRepository({
    required Dio dio,
    required SettingsRepository settingsRepository,
  })  : _dio = dio,
        _settingsRepository = settingsRepository;

  @override
  Future<String> generate({
    required String systemPrompt,
    required List<ChatMessage> messages,
    Object? cancelToken,
  }) async {
    final baseUrl = _settingsRepository.getBaseUrl();
    final apiKey = _settingsRepository.getApiKey();
    final model = _settingsRepository.getModelName();

    try {
      final response = await _dio.post(
        '$baseUrl/chat/completions',
        data: {
          'model': model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            ...messages.map((m) => {'role': m.role, 'content': m.content}),
          ],
          'temperature': 0.7,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
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
      if (e.response?.statusCode == 401) {
        throw Exception('Ошибка API: 401 Unauthorized. Проверьте ваш API ключ в настройках.');
      }
      throw Exception('Ошибка API: ${e.message}');
    } catch (e) {
      throw Exception('Непредвиденная ошибка: $e');
    }
  }
}
