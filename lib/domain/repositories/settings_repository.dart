import '../entities/reflection_mode.dart';

abstract class SettingsRepository {
  Future<void> setMaxDuration(int seconds);
  int getMaxDuration();

  Future<void> setReflectionMode(ReflectionMode mode);
  ReflectionMode getReflectionMode();
}
