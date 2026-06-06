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
  
  /// The maximum duration for reflection in seconds.
  late int _maxDuration;
  
  /// The currently selected reflection mode.
  late ReflectionMode _reflectionMode;

  @override
  void initState() {
    super.initState();
    _maxDuration = _settingsRepository.getMaxDuration();
    _reflectionMode = _settingsRepository.getReflectionMode();
  }

  /// Updates and persists the maximum duration.
  void _saveDuration(double value) {
    setState(() {
      _maxDuration = value.toInt();
    });
    _settingsRepository.setMaxDuration(_maxDuration);
  }

  /// Updates and persists the reflection mode.
  void _saveMode(ReflectionMode? mode) {
    if (mode == null) return;
    setState(() {
      _reflectionMode = mode;
    });
    _settingsRepository.setReflectionMode(mode);
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
            'Response Duration (sec)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _maxDuration.toDouble(),
            min: 5,
            max: 120,
            divisions: 23,
            label: '$_maxDuration sec',
            onChanged: _saveDuration,
          ),
          Center(child: Text('$_maxDuration seconds')),
          const SizedBox(height: 32),
          const Text(
            'Reflection Mode',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
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
        ],
      ),
    );
  }
}
