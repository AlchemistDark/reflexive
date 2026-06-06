import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/reflection_mode.dart';
import '../../domain/repositories/settings_repository.dart';

class SharedPrefsSettingsRepository implements SettingsRepository {
  final SharedPreferences _prefs;
  static const _keyMaxDuration = 'max_duration';
  static const _keyReflectionMode = 'reflection_mode';

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
}
