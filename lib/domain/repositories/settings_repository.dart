import 'package:reflexive/domain/entities/reflection_mode.dart';

/// Repository interface for managing application settings.
abstract class SettingsRepository {
  /// Persists the maximum duration for the reflection process in seconds.
  Future<void> setMaxDuration(int seconds);

  /// Retrieves the saved maximum duration in seconds.
  int getMaxDuration();

  /// Persists the maximum number of iterations.
  Future<void> setMaxIterations(int count);

  /// Retrieves the saved maximum number of iterations.
  int getMaxIterations();

  /// Persists whether the process should stop if no issues are found.
  Future<void> setStopOnNoIssues(bool stop);

  /// Retrieves whether the process should stop if no issues are found.
  bool getStopOnNoIssues();

  /// Persists the selected reflection mode.
  Future<void> setReflectionMode(ReflectionMode mode);

  /// Retrieves the currently selected reflection mode.
  ReflectionMode getReflectionMode();

  /// Persists the API key for the LLM provider.
  Future<void> setApiKey(String apiKey);

  /// Retrieves the saved API key.
  String getApiKey();

  /// Persists the model name.
  Future<void> setModelName(String modelName);

  /// Retrieves the saved model name.
  String getModelName();

  /// Persists the base URL for the LLM provider.
  Future<void> setBaseUrl(String baseUrl);

  /// Retrieves the saved base URL.
  String getBaseUrl();
}
