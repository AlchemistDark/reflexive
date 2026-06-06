import 'package:flutter/material.dart';
import 'package:reflexive/core/di/injection_container.dart';
import 'package:reflexive/domain/entities/reflection_mode.dart';
import 'package:reflexive/domain/repositories/settings_repository.dart';

/// Screen for managing application settings like response duration and reflection mode.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  /// Instance of the settings repository.
  final _settingsRepository = sl<SettingsRepository>();

  /// Controllers for text fields.
  late TextEditingController _durationController;
  late TextEditingController _iterationsController;
  late TextEditingController _apiKeyController;
  late TextEditingController _modelController;
  late TextEditingController _baseUrlController;

  /// The currently selected reflection mode.
  late ReflectionMode _reflectionMode;

  /// Whether to stop if no issues are found.
  late bool _stopOnNoIssues;

  @override
  void initState() {
    super.initState();
    _durationController = TextEditingController(
      text: _settingsRepository.getMaxDuration().toString(),
    );
    _iterationsController = TextEditingController(
      text: _settingsRepository.getMaxIterations().toString(),
    );
    _apiKeyController = TextEditingController(
      text: _settingsRepository.getApiKey(),
    );
    _modelController = TextEditingController(
      text: _settingsRepository.getModelName(),
    );
    _baseUrlController = TextEditingController(
      text: _settingsRepository.getBaseUrl(),
    );
    _reflectionMode = _settingsRepository.getReflectionMode();
    _stopOnNoIssues = _settingsRepository.getStopOnNoIssues();
  }

  @override
  void dispose() {
    _durationController.dispose();
    _iterationsController.dispose();
    _apiKeyController.dispose();
    _modelController.dispose();
    _baseUrlController.dispose();
    super.dispose();
  }

  /// Saves the API key.
  void _saveApiKey(String value) {
    _settingsRepository.setApiKey(value);
  }

  /// Saves the model name.
  void _saveModelName(String value) {
    _settingsRepository.setModelName(value);
  }

  /// Saves the base URL.
  void _saveBaseUrl(String value) {
    _settingsRepository.setBaseUrl(value);
  }

  /// Saves the duration from the text field.
  void _saveDuration(String value) {
    final seconds = int.tryParse(value);
    if (seconds != null && seconds > 0) {
      _settingsRepository.setMaxDuration(seconds);
    }
  }

  /// Saves the iterations from the text field.
  void _saveIterations(String value) {
    final count = int.tryParse(value);
    if (count != null && count > 0) {
      _settingsRepository.setMaxIterations(count);
    }
  }

  /// Updates and persists the reflection mode.
  void _saveMode(ReflectionMode? mode) {
    if (mode == null) return;
    setState(() {
      _reflectionMode = mode;
    });
    _settingsRepository.setReflectionMode(mode);
  }

  /// Updates and persists the "Stop on no issues" setting.
  void _saveStopOnNoIssues(bool value) {
    setState(() {
      _stopOnNoIssues = value;
    });
    _settingsRepository.setStopOnNoIssues(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Stopping Criteria',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ListTile(
            title: const Text('Max Duration (seconds)'),
            trailing: SizedBox(
              width: 80,
              child: TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                onChanged: _saveDuration,
                decoration: const InputDecoration(isDense: true),
              ),
            ),
          ),
          ListTile(
            title: const Text('Max Iterations'),
            trailing: SizedBox(
              width: 80,
              child: TextField(
                controller: _iterationsController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                onChanged: _saveIterations,
                decoration: const InputDecoration(isDense: true),
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Stop if no issues found'),
            subtitle: const Text('Exit early if the Critic finds no flaws'),
            value: _stopOnNoIssues,
            onChanged: _saveStopOnNoIssues,
          ),
          const SizedBox(height: 24),
          const Text(
            'Reflection Strategy',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ...ReflectionMode.values.map((mode) {
            return RadioListTile<ReflectionMode>(
              title: Text(mode.displayName),
              subtitle: Text(mode == ReflectionMode.standard
                  ? 'Standard approach: focus on error detection and accuracy.'
                  : 'Devil\'s Advocate: focus on finding weak points and logical gaps.'),
              value: mode,
              groupValue: _reflectionMode,
              onChanged: _saveMode,
            );
          }),
          const SizedBox(height: 24),
          const Text(
            'LLM Configuration',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 8),
          TextField(
            controller: _apiKeyController,
            decoration: const InputDecoration(
              labelText: 'API Key',
              border: OutlineInputBorder(),
              hintText: 'sk-...',
            ),
            obscureText: true,
            onChanged: _saveApiKey,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _baseUrlController,
            decoration: const InputDecoration(
              labelText: 'Base URL',
              border: OutlineInputBorder(),
              hintText: 'https://api.openai.com/v1',
            ),
            onChanged: _saveBaseUrl,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _modelController,
            decoration: const InputDecoration(
              labelText: 'Model Name',
              border: OutlineInputBorder(),
              hintText: 'gpt-4o',
            ),
            onChanged: _saveModelName,
          ),
        ],
      ),
    );
  }
}
