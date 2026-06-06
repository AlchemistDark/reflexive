class TimePreset {
  final String name;
  final Duration maxDuration;
  final int maxIterations;

  const TimePreset({
    required this.name,
    required this.maxDuration,
    required this.maxIterations,
  });

  static const fast = TimePreset(
    name: "Быстрый",
    maxDuration: Duration(seconds: 10),
    maxIterations: 2,
  );

  static const normal = TimePreset(
    name: "Обычный",
    maxDuration: Duration(seconds: 30),
    maxIterations: 5,
  );

  static const deep = TimePreset(
    name: "Глубокий",
    maxDuration: Duration(seconds: 60),
    maxIterations: 10,
  );
}
