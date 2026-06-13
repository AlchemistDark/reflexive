import 'package:reflexive/domain/entities/reflection_mode.dart';
import 'package:reflexive/domain/entities/llm_provider.dart';

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

  /// Persists the selected LLM provider.
  Future<void> setLlmProvider(LlmProvider provider);

  /// Retrieves the currently selected LLM provider.
  LlmProvider getLlmProvider();

  /// Persists the delay between requests in milliseconds.
  Future<void> setRequestDelay(int milliseconds);

  /// Retrieves the saved delay between requests in milliseconds.
  int getRequestDelay();

  /// Persists the system architecture prompt.
  Future<void> setSystemArchitecturePrompt(String prompt);

  /// Retrieves the system architecture prompt.
  String getSystemArchitecturePrompt();

  /// Persists the math formatting prompt.
  Future<void> setMathPrompt(String prompt);

  /// Retrieves the math formatting prompt.
  String getMathPrompt();

  /// Persists the prompt for the Generator role.
  Future<void> setGeneratorPrompt(String prompt);

  /// Retrieves the prompt for the Generator role.
  String getGeneratorPrompt();

  /// Persists the prompt for the Critic role.
  Future<void> setCriticPrompt(String prompt);

  /// Retrieves the prompt for the Critic role.
  String getCriticPrompt();

  /// Persists the prompt for the Devil's Advocate role.
  Future<void> setDevilsAdvocatePrompt(String prompt);

  /// Retrieves the prompt for the Devil's Advocate role.
  String getDevilsAdvocatePrompt();

  /// Persists the prompt for the Editor role.
  Future<void> setEditorPrompt(String prompt);

  /// Retrieves the prompt for the Editor role.
  String getEditorPrompt();

  /// Resets all prompts to their default values.
  Future<void> resetAllPrompts();

  /// Resets a specific prompt to its default value.
  Future<void> resetSystemArchitecturePrompt();
  Future<void> resetMathPrompt();
  Future<void> resetGeneratorPrompt();
  Future<void> resetCriticPrompt();
  Future<void> resetDevilsAdvocatePrompt();
  Future<void> resetEditorPrompt();

  /// Exports the current prompt configurations as a JSON string.
  String exportPrompts();

  /// Imports prompt configurations from a JSON string.
  Future<void> importPrompts(String json);

  /// Persists whether internet search is enabled.
  Future<void> setUseInternet(bool enabled);

  /// Retrieves whether internet search is enabled.
  bool getUseInternet();
}
