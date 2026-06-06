enum ReflectionMode {
  standard,
  devilsAdvocate;

  String get displayName {
    switch (this) {
      case ReflectionMode.standard:
        return 'Стандартный (Ошибки и точность)';
      case ReflectionMode.devilsAdvocate:
        return 'Адвокат дьявола (Слабые места и логика)';
    }
  }
}
