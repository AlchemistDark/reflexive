import 'package:shared_preferences/shared_preferences.dart';
import 'package:reflexive/domain/entities/reflection_mode.dart';
import 'package:reflexive/domain/entities/llm_provider.dart';
import 'package:reflexive/domain/repositories/settings_repository.dart';

/// Implementation of [SettingsRepository] using [SharedPreferences] for persistent storage.
class SharedPrefsSettingsRepository implements SettingsRepository {
  final SharedPreferences _prefs;
  static const _keyMaxDuration = 'max_duration';
  static const _keyMaxIterations = 'max_iterations';
  static const _keyStopOnNoIssues = 'stop_on_no_issues';
  static const _keyReflectionMode = 'reflection_mode';
  static const _keyApiKey = 'api_key';
  static const _keyModelName = 'model_name';
  static const _keyBaseUrl = 'base_url';
  static const _keyLlmProvider = 'llm_provider';

  /// Creates a new instance of [SharedPrefsSettingsRepository].
  SharedPrefsSettingsRepository(this._prefs);

  @override
  int getMaxDuration() {
    return _prefs.getInt(_keyMaxDuration) ?? 30; // Default 30 seconds
  }

  @override
  Future<void> setMaxDuration(int seconds) async {
    await _prefs.setInt(_keyMaxDuration, seconds);
  }

  @override
  int getMaxIterations() {
    return _prefs.getInt(_keyMaxIterations) ?? 5; // Default 5 iterations
  }

  @override
  Future<void> setMaxIterations(int count) async {
    await _prefs.setInt(_keyMaxIterations, count);
  }

  @override
  bool getStopOnNoIssues() {
    return _prefs.getBool(_keyStopOnNoIssues) ?? true; // Default true
  }

  @override
  Future<void> setStopOnNoIssues(bool stop) async {
    await _prefs.setBool(_keyStopOnNoIssues, stop);
  }

  @override
  ReflectionMode getReflectionMode() {
    final index = _prefs.getInt(_keyReflectionMode);
    if (index == null || index >= ReflectionMode.values.length) {
      return ReflectionMode.standard;
    }
    return ReflectionMode.values[index];
  }

  @override
  Future<void> setReflectionMode(ReflectionMode mode) async {
    await _prefs.setInt(_keyReflectionMode, mode.index);
  }

  @override
  String getApiKey() {
    return _prefs.getString(_keyApiKey) ?? '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';
  }

  @override
  Future<void> setApiKey(String apiKey) async {
    await _prefs.setString(_keyApiKey, apiKey);
  }

  @override
  String getModelName() {
    return _prefs.getString(_keyModelName) ?? 'openrouter/auto';
  }

  @override
  Future<void> setModelName(String modelName) async {
    await _prefs.setString(_keyModelName, modelName);
  }

  @override
  String getBaseUrl() {
    return _prefs.getString(_keyBaseUrl) ?? 'https://openrouter.ai/api/v1';
  }

  @override
  Future<void> setBaseUrl(String baseUrl) async {
    await _prefs.setString(_keyBaseUrl, baseUrl);
  }

  @override
  LlmProvider getLlmProvider() {
    final index = _prefs.getInt(_keyLlmProvider);
    if (index == null || index >= LlmProvider.values.length) {
      return LlmProvider.openRouter;
    }
    return LlmProvider.values[index];
  }

  @override
  Future<void> setLlmProvider(LlmProvider provider) async {
    await _prefs.setInt(_keyLlmProvider, provider.index);
  }
}
