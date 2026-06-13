import 'package:dio/dio.dart';
import 'package:reflexive/domain/entities/chat_message.dart';
import 'package:reflexive/domain/entities/llm_provider.dart';
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
    final provider = _settingsRepository.getLlmProvider();
    var model = _settingsRepository.getModelName();

    // Support "auto" or "default" keywords
    if (model.toLowerCase() == 'auto' || model.toLowerCase() == 'default' || model.isEmpty) {
      model = provider.defaultModel;
    }

    // Ensure model name does NOT have 'models/' prefix for OpenAI-compatible endpoint
    // even if the user manually typed it.
    final cleanModel = model.startsWith('models/') ? model.replaceFirst('models/', '') : model;

    // Ensure baseUrl doesn't have a trailing slash before adding path
    final cleanBaseUrl = baseUrl.endsWith('/') 
        ? baseUrl.substring(0, baseUrl.length - 1) 
        : baseUrl.trim();
    
    final fullUrl = '$cleanBaseUrl/chat/completions';

    final Map<String, dynamic> requestBody = {
      'model': cleanModel,
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        ...messages.map((m) => {'role': m.role, 'content': m.content}),
      ],
      'temperature': 0.7,
    };

    if (_settingsRepository.getUseInternet()) {
      // For OpenRouter and some other providers, web search can be enabled via extra parameters
      if (provider == LlmProvider.openRouter) {
        requestBody['plugins'] = [
          {'id': 'web_search'}
        ];
      } else if (provider == LlmProvider.google) {
        // Google AI Studio OpenAI-compatible endpoint tool support for search
        requestBody['tools'] = [
          {
            'google_search_retrieval': {
              'dynamic_retrieval_config': {
                'mode': 'MODE_DYNAMIC',
                'dynamic_threshold': 0.3,
              }
            }
          }
        ];
      }
    }

    try {
      final response = await _dio.post(
        fullUrl,
        data: requestBody,
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
      final statusCode = e.response?.statusCode;
      if (statusCode == 404) {
        throw Exception('Ошибка API: 404 Not Found. Неверный URL или модель.\n'
            'URL: $fullUrl\n'
            'Model: $cleanModel\n'
            'Убедитесь, что в настройках Base URL: https://generativelanguage.googleapis.com/v1beta/openai');
      }
      if (statusCode == 401) {
        throw Exception('Ошибка API: 401 Unauthorized. Проверьте ваш API ключ.');
      }
      if (statusCode == 429) {
        throw Exception('Ошибка API: 429 Too Many Requests. Превышен лимит запросов.');
      }
      if (statusCode == 400) {
        final errorData = e.response?.data;
        throw Exception('Ошибка API: 400 Bad Request. ${errorData ?? e.message}');
      }
      throw Exception('Ошибка API: ${e.message}');
    } catch (e) {
      throw Exception('Непредвиденная ошибка: $e');
    }
  }
}
