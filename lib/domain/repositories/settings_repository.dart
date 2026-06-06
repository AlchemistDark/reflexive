import 'package:reflexive/domain/entities/reflection_mode.dart';

/// Repository interface for managing application settings.
abstract class SettingsRepository {
  /// Persists the maximum duration for the reflection process in seconds.
  Future<void> setMaxDuration(int seconds);

  /// Retrieves the saved maximum duration in seconds.
  int getMaxDuration();

  /// Persists the selected reflection mode.
  Future<void> setReflectionMode(ReflectionMode mode);

  /// Retrieves the currently selected reflection mode.
  ReflectionMode getReflectionMode();
}
