/// Represents the mode of the reflection process.
enum ReflectionMode {
  /// Standard mode focusing on error detection and accuracy improvement.
  standard,

  /// Devil's Advocate mode focusing on identifying weak points and logical gaps.
  devilsAdvocate;

  /// Returns the human-readable display name for the mode.
  String get displayName {
    switch (this) {
      case ReflectionMode.standard:
        return 'Стандартный (Ошибки и точность)';
      case ReflectionMode.devilsAdvocate:
        return 'Адвокат дьявола (Слабые места и логика)';
    }
  }
}
