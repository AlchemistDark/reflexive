import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:reflexive/core/di/injection_container.dart';
import 'package:reflexive/domain/entities/reflection_mode.dart';
import 'package:reflexive/domain/entities/llm_provider.dart';
import 'package:reflexive/domain/repositories/settings_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late TextEditingController _delayController;

  // Prompt controllers
  late TextEditingController _systemArchitectureController;
  late TextEditingController _mathPromptController;
  late TextEditingController _generatorPromptController;
  late TextEditingController _criticPromptController;
  late TextEditingController _devilsAdvocatePromptController;
  late TextEditingController _editorPromptController;

  /// The currently selected reflection mode.
  late ReflectionMode _reflectionMode;

  /// The currently selected LLM provider.
  late LlmProvider _llmProvider;

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
    _delayController = TextEditingController(
      text: _settingsRepository.getRequestDelay().toString(),
    );
    
    // Initialize prompt controllers
    _systemArchitectureController = TextEditingController(
      text: _settingsRepository.getSystemArchitecturePrompt(),
    );
    _mathPromptController = TextEditingController(
      text: _settingsRepository.getMathPrompt(),
    );
    _generatorPromptController = TextEditingController(
      text: _settingsRepository.getGeneratorPrompt(),
    );
    _criticPromptController = TextEditingController(
      text: _settingsRepository.getCriticPrompt(),
    );
    _devilsAdvocatePromptController = TextEditingController(
      text: _settingsRepository.getDevilsAdvocatePrompt(),
    );
    _editorPromptController = TextEditingController(
      text: _settingsRepository.getEditorPrompt(),
    );

    _reflectionMode = _settingsRepository.getReflectionMode();
    _llmProvider = _settingsRepository.getLlmProvider();
    _stopOnNoIssues = _settingsRepository.getStopOnNoIssues();
  }

  @override
  void dispose() {
    _durationController.dispose();
    _iterationsController.dispose();
    _apiKeyController.dispose();
    _modelController.dispose();
    _baseUrlController.dispose();
    _delayController.dispose();
    _systemArchitectureController.dispose();
    _mathPromptController.dispose();
    _generatorPromptController.dispose();
    _criticPromptController.dispose();
    _devilsAdvocatePromptController.dispose();
    _editorPromptController.dispose();
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

  /// Updates and persists the LLM provider.
  void _saveProvider(LlmProvider? provider) {
    if (provider == null) return;
    setState(() {
      _llmProvider = provider;
      if (provider != LlmProvider.custom) {
        _baseUrlController.text = provider.defaultBaseUrl;
        _modelController.text = 'auto'; // Устанавливаем auto для автоматического выбора
        _settingsRepository.setBaseUrl(provider.defaultBaseUrl);
        _settingsRepository.setModelName('auto');
      }
    });
    _settingsRepository.setLlmProvider(provider);
  }

  /// Updates and persists the "Stop on no issues" setting.
  void _saveStopOnNoIssues(bool value) {
    setState(() {
      _stopOnNoIssues = value;
    });
    _settingsRepository.setStopOnNoIssues(value);
  }

  /// Saves the request delay from the text field.
  void _saveRequestDelay(String value) {
    final ms = int.tryParse(value);
    if (ms != null && ms >= 0) {
      _settingsRepository.setRequestDelay(ms);
    }
  }

  void _saveSystemArchitecture(String value) => _settingsRepository.setSystemArchitecturePrompt(value);
  void _saveMathPrompt(String value) => _settingsRepository.setMathPrompt(value);
  void _saveGeneratorPrompt(String value) => _settingsRepository.setGeneratorPrompt(value);
  void _saveCriticPrompt(String value) => _settingsRepository.setCriticPrompt(value);
  void _saveDevilsAdvocatePrompt(String value) => _settingsRepository.setDevilsAdvocatePrompt(value);
  void _saveEditorPrompt(String value) => _settingsRepository.setEditorPrompt(value);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.settings),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.general, icon: const Icon(Icons.settings)),
              Tab(text: l10n.prompts, icon: const Icon(Icons.edit_note)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGeneralTab(l10n),
            _buildPromptsTab(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralTab(AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          l10n.stoppingCriteria,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        ListTile(
          title: Text(l10n.maxDuration),
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
          title: Text(l10n.maxIterations),
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
        ListTile(
          title: Text(l10n.requestDelay),
          subtitle: Text(l10n.requestDelaySubtitle),
          trailing: SizedBox(
            width: 80,
            child: TextField(
              controller: _delayController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              onChanged: _saveRequestDelay,
              decoration: const InputDecoration(isDense: true),
            ),
          ),
        ),
        SwitchListTile(
          title: Text(l10n.stopIfNoIssues),
          subtitle: Text(l10n.stopIfNoIssuesSubtitle),
          value: _stopOnNoIssues,
          onChanged: _saveStopOnNoIssues,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.reflectionStrategy,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        Text(
          l10n.llmConfiguration,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        const SizedBox(height: 8),
        DropdownButtonFormField<LlmProvider>(
          value: _llmProvider,
          decoration: InputDecoration(
            labelText: l10n.provider,
            border: const OutlineInputBorder(),
          ),
          items: LlmProvider.values.map((provider) {
            return DropdownMenuItem(
              value: provider,
              child: Text(provider.displayName),
            );
          }).toList(),
          onChanged: _saveProvider,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _apiKeyController,
          decoration: InputDecoration(
            labelText: l10n.apiKey,
            border: const OutlineInputBorder(),
            hintText: 'sk-...',
          ),
          obscureText: true,
          onChanged: _saveApiKey,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _baseUrlController,
          decoration: InputDecoration(
            labelText: l10n.baseUrl,
            border: const OutlineInputBorder(),
            hintText: 'https://api.openai.com/v1',
            suffixIcon: IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: l10n.resetToProviderDefault,
              onPressed: () {
                setState(() {
                  _baseUrlController.text = _llmProvider.defaultBaseUrl;
                  _settingsRepository.setBaseUrl(_llmProvider.defaultBaseUrl);
                });
              },
            ),
          ),
          onChanged: _saveBaseUrl,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _modelController,
          decoration: InputDecoration(
            labelText: l10n.modelName,
            border: const OutlineInputBorder(),
            hintText: 'gpt-4o',
            helperText: l10n.modelNameHelper,
            suffixIcon: IconButton(
              icon: const Icon(Icons.auto_awesome),
              tooltip: l10n.resetToDefault,
              onPressed: () {
                setState(() {
                  _modelController.text = 'auto';
                  _settingsRepository.setModelName('auto');
                });
              },
            ),
          ),
          onChanged: _saveModelName,
        ),
      ],
    );
  }

  Widget _buildPromptsTab(AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildPromptField(
          l10n.systemArchitecture,
          l10n.systemArchitectureHelper,
          _systemArchitectureController,
          _saveSystemArchitecture,
          _settingsRepository.resetSystemArchitecturePrompt,
        ),
        _buildPromptField(
          l10n.mathFormatting,
          l10n.mathFormattingHelper,
          _mathPromptController,
          _saveMathPrompt,
          _settingsRepository.resetMathPrompt,
        ),
        _buildPromptField(
          l10n.generatorRole,
          l10n.generatorRoleHelper,
          _generatorPromptController,
          _saveGeneratorPrompt,
          _settingsRepository.resetGeneratorPrompt,
        ),
        _buildPromptField(
          l10n.criticRole,
          l10n.criticRoleHelper,
          _criticPromptController,
          _saveCriticPrompt,
          _settingsRepository.resetCriticPrompt,
        ),
        _buildPromptField(
          l10n.devilsAdvocateRole,
          l10n.devilsAdvocateRoleHelper,
          _devilsAdvocatePromptController,
          _saveDevilsAdvocatePrompt,
          _settingsRepository.resetDevilsAdvocatePrompt,
        ),
        _buildPromptField(
          l10n.editorRole,
          l10n.editorRoleHelper,
          _editorPromptController,
          _saveEditorPrompt,
          _settingsRepository.resetEditorPrompt,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final json = _settingsRepository.exportPrompts();
                  await Clipboard.setData(ClipboardData(text: json));
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.exportSuccess)),
                    );
                  }
                },
                icon: const Icon(Icons.copy),
                label: Text(l10n.exportPrompts),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final data = await Clipboard.getData(Clipboard.kTextPlain);
                  if (data?.text != null) {
                    try {
                      await _settingsRepository.importPrompts(data!.text!);
                      setState(() {
                        _systemArchitectureController.text = _settingsRepository.getSystemArchitecturePrompt();
                        _mathPromptController.text = _settingsRepository.getMathPrompt();
                        _generatorPromptController.text = _settingsRepository.getGeneratorPrompt();
                        _criticPromptController.text = _settingsRepository.getCriticPrompt();
                        _devilsAdvocatePromptController.text = _settingsRepository.getDevilsAdvocatePrompt();
                        _editorPromptController.text = _settingsRepository.getEditorPrompt();
                      });
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.importSuccess)),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.importError)),
                        );
                      }
                    }
                  }
                },
                icon: const Icon(Icons.paste),
                label: Text(l10n.importPrompts),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () async {
            await _settingsRepository.resetAllPrompts();
            setState(() {
              _systemArchitectureController.text = _settingsRepository.getSystemArchitecturePrompt();
              _mathPromptController.text = _settingsRepository.getMathPrompt();
              _generatorPromptController.text = _settingsRepository.getGeneratorPrompt();
              _criticPromptController.text = _settingsRepository.getCriticPrompt();
              _devilsAdvocatePromptController.text = _settingsRepository.getDevilsAdvocatePrompt();
              _editorPromptController.text = _settingsRepository.getEditorPrompt();
            });
          },
          icon: const Icon(Icons.restore),
          label: Text(l10n.resetToDefault),
        ),
      ],
    );
  }

  Widget _buildPromptField(
    String label,
    String helper,
    TextEditingController controller,
    Function(String) onChanged,
    Future<void> Function() onReset,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: () async {
                  await onReset();
                  setState(() {
                    // We need a way to get the default value or re-read from repo
                    // Since the repo returns default if null, we just re-read.
                    if (onReset == _settingsRepository.resetSystemArchitecturePrompt) {
                      controller.text = _settingsRepository.getSystemArchitecturePrompt();
                    } else if (onReset == _settingsRepository.resetMathPrompt) {
                      controller.text = _settingsRepository.getMathPrompt();
                    } else if (onReset == _settingsRepository.resetGeneratorPrompt) {
                      controller.text = _settingsRepository.getGeneratorPrompt();
                    } else if (onReset == _settingsRepository.resetCriticPrompt) {
                      controller.text = _settingsRepository.getCriticPrompt();
                    } else if (onReset == _settingsRepository.resetDevilsAdvocatePrompt) {
                      controller.text = _settingsRepository.getDevilsAdvocatePrompt();
                    } else if (onReset == _settingsRepository.resetEditorPrompt) {
                      controller.text = _settingsRepository.getEditorPrompt();
                    }
                  });
                },
                tooltip: AppLocalizations.of(context)!.resetToDefault,
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: null,
            decoration: InputDecoration(
              helperText: helper,
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

