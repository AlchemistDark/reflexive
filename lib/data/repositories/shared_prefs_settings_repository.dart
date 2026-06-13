import 'dart:convert';
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
  static const _keyRequestDelay = 'request_delay';
  static const _keySystemArchitecture = 'system_architecture';
  static const _keyMathPrompt = 'math_prompt';
  static const _keyGeneratorPrompt = 'generator_prompt';
  static const _keyCriticPrompt = 'critic_prompt';
  static const _keyDevilsAdvocatePrompt = 'devils_advocate_prompt';
  static const _keyEditorPrompt = 'editor_prompt';

  // Default Prompts
  static const defaultSystemArchitecture = "You are the central intelligence of the 'Reflexive Agent'. You perform a multi-role reflection process where you sequentially act as Generator, Critic, and Editor. Your goal is self-improvement through iterative analysis. You are responsible for both creating the content and identifying your own mistakes to ensure the final output is flawless. The process follows these stages: GENERATION -> CRITIQUE -> IMPROVEMENT. ";
  static const defaultMathPrompt = " IMPORTANT: Use LaTeX for all mathematical formulas. Use \\( ... \\) for inline math and \\[ ... \\] for block math.";
  static const defaultGeneratorPrompt = "Current Role: GENERATOR. Create the first comprehensive draft of the answer. Since you will later critique this draft yourself, try to make it as solid as possible from the start.";
  static const defaultCriticPrompt = "Current Role: CRITIC (Self-Review). Review your own previous draft for accuracy, clarity, and completeness. Identify what YOU can do better. Output a list of improvements. If no changes are needed, output only: NO_ISSUES.";
  static const defaultDevilsAdvocatePrompt = "Current Role: CRITIC (Devil's Advocate). Now, objectively analyze YOUR OWN previous draft. Search for hidden flaws, weak logic, and assumptions you might have missed. Be brutally honest with yourself. Output your self-critique as a list. If perfect, output: NO_ISSUES.";
  static const defaultEditorPrompt = "Current Role: EDITOR. This is the final stage of your reflection. Combine your original draft and your own critique to produce a perfect, polished version. Output ONLY the final answer content. Do not talk to the user about the process.";

  /// Creates a new instance of [SharedPrefsSettingsRepository].
  SharedPrefsSettingsRepository(this._prefs);

  @override
  String getSystemArchitecturePrompt() {
    return _prefs.getString(_keySystemArchitecture) ?? defaultSystemArchitecture;
  }

  @override
  Future<void> setSystemArchitecturePrompt(String prompt) async {
    await _prefs.setString(_keySystemArchitecture, prompt);
  }

  @override
  String getMathPrompt() {
    return _prefs.getString(_keyMathPrompt) ?? defaultMathPrompt;
  }

  @override
  Future<void> setMathPrompt(String prompt) async {
    await _prefs.setString(_keyMathPrompt, prompt);
  }

  @override
  String getGeneratorPrompt() {
    return _prefs.getString(_keyGeneratorPrompt) ?? defaultGeneratorPrompt;
  }

  @override
  Future<void> setGeneratorPrompt(String prompt) async {
    await _prefs.setString(_keyGeneratorPrompt, prompt);
  }

  @override
  String getCriticPrompt() {
    return _prefs.getString(_keyCriticPrompt) ?? defaultCriticPrompt;
  }

  @override
  Future<void> setCriticPrompt(String prompt) async {
    await _prefs.setString(_keyCriticPrompt, prompt);
  }

  @override
  String getDevilsAdvocatePrompt() {
    return _prefs.getString(_keyDevilsAdvocatePrompt) ?? defaultDevilsAdvocatePrompt;
  }

  @override
  Future<void> setDevilsAdvocatePrompt(String prompt) async {
    await _prefs.setString(_keyDevilsAdvocatePrompt, prompt);
  }

  @override
  String getEditorPrompt() {
    return _prefs.getString(_keyEditorPrompt) ?? defaultEditorPrompt;
  }

  @override
  Future<void> setEditorPrompt(String prompt) async {
    await _prefs.setString(_keyEditorPrompt, prompt);
  }

  @override
  int getRequestDelay() {
    return _prefs.getInt(_keyRequestDelay) ?? 2000;
  }

  @override
  Future<void> setRequestDelay(int milliseconds) async {
    await _prefs.setInt(_keyRequestDelay, milliseconds);
  }

  @override
  int getMaxDuration() {
    return _prefs.getInt(_keyMaxDuration) ?? 30;
  }

  @override
  Future<void> setMaxDuration(int seconds) async {
    await _prefs.setInt(_keyMaxDuration, seconds);
  }

  @override
  int getMaxIterations() {
    return _prefs.getInt(_keyMaxIterations) ?? 5;
  }

  @override
  Future<void> setMaxIterations(int count) async {
    await _prefs.setInt(_keyMaxIterations, count);
  }

  @override
  bool getStopOnNoIssues() {
    return _prefs.getBool(_keyStopOnNoIssues) ?? true;
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

  @override
  Future<void> resetAllPrompts() async {
    await resetSystemArchitecturePrompt();
    await resetMathPrompt();
    await resetGeneratorPrompt();
    await resetCriticPrompt();
    await resetDevilsAdvocatePrompt();
    await resetEditorPrompt();
  }

  @override
  Future<void> resetSystemArchitecturePrompt() async {
    await _prefs.remove(_keySystemArchitecture);
  }

  @override
  Future<void> resetMathPrompt() async {
    await _prefs.remove(_keyMathPrompt);
  }

  @override
  Future<void> resetGeneratorPrompt() async {
    await _prefs.remove(_keyGeneratorPrompt);
  }

  @override
  Future<void> resetCriticPrompt() async {
    await _prefs.remove(_keyCriticPrompt);
  }

  @override
  Future<void> resetDevilsAdvocatePrompt() async {
    await _prefs.remove(_keyDevilsAdvocatePrompt);
  }

  @override
  Future<void> resetEditorPrompt() async {
    await _prefs.remove(_keyEditorPrompt);
  }

  @override
  String exportPrompts() {
    final Map<String, String> prompts = {
      _keySystemArchitecture: getSystemArchitecturePrompt(),
      _keyMathPrompt: getMathPrompt(),
      _keyGeneratorPrompt: getGeneratorPrompt(),
      _keyCriticPrompt: getCriticPrompt(),
      _keyDevilsAdvocatePrompt: getDevilsAdvocatePrompt(),
      _keyEditorPrompt: getEditorPrompt(),
    };
    return jsonEncode(prompts);
  }

  @override
  Future<void> importPrompts(String json) async {
    try {
      final Map<String, dynamic> prompts = jsonDecode(json);
      if (prompts.containsKey(_keySystemArchitecture)) {
        await setSystemArchitecturePrompt(prompts[_keySystemArchitecture]);
      }
      if (prompts.containsKey(_keyMathPrompt)) {
        await setMathPrompt(prompts[_keyMathPrompt]);
      }
      if (prompts.containsKey(_keyGeneratorPrompt)) {
        await setGeneratorPrompt(prompts[_keyGeneratorPrompt]);
      }
      if (prompts.containsKey(_keyCriticPrompt)) {
        await setCriticPrompt(prompts[_keyCriticPrompt]);
      }
      if (prompts.containsKey(_keyDevilsAdvocatePrompt)) {
        await setDevilsAdvocatePrompt(prompts[_keyDevilsAdvocatePrompt]);
      }
      if (prompts.containsKey(_keyEditorPrompt)) {
        await setEditorPrompt(prompts[_keyEditorPrompt]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
