import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/reflection_mode.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settingsRepository = sl<SettingsRepository>();
  late int _maxDuration;
  late ReflectionMode _reflectionMode;

  @override
  void initState() {
    super.initState();
    _maxDuration = _settingsRepository.getMaxDuration();
    _reflectionMode = _settingsRepository.getReflectionMode();
  }

  void _saveDuration(double value) {
    setState(() {
      _maxDuration = value.toInt();
    });
    _settingsRepository.setMaxDuration(_maxDuration);
  }

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
        title: const Text('Настройки'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Длительность ответа (сек)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _maxDuration.toDouble(),
            min: 5,
            max: 120,
            divisions: 23,
            label: '$_maxDuration сек',
            onChanged: _saveDuration,
          ),
          Center(child: Text('$_maxDuration секунд')),
          const SizedBox(height: 32),
          const Text(
            'Режим рефлексии',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...ReflectionMode.values.map((mode) {
            return RadioListTile<ReflectionMode>(
              title: Text(mode.displayName),
              subtitle: Text(mode == ReflectionMode.standard 
                ? 'Классический подход: поиск ошибок и улучшение точности.' 
                : 'Критический подход: поиск слабых мест и проверка логики.'),
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
