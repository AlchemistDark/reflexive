/// Represents a configuration for the reflection process timing and depth.
class TimePreset {
  /// The display name of the preset.
  final String name;

  /// The maximum duration allowed for the reflection process.
  final Duration maxDuration;

  /// The maximum number of reflection iterations allowed.
  final int maxIterations;

  const TimePreset({
    required this.name,
    required this.maxDuration,
    required this.maxIterations,
  });

  /// Fast preset: 10 seconds, 2 iterations.
  static const fast = TimePreset(
    name: "Быстрый",
    maxDuration: Duration(seconds: 10),
    maxIterations: 2,
  );

  /// Normal preset: 30 seconds, 5 iterations.
  static const normal = TimePreset(
    name: "Обычный",
    maxDuration: Duration(seconds: 30),
    maxIterations: 5,
  );

  /// Deep preset: 60 seconds, 10 iterations.
  static const deep = TimePreset(
    name: "Глубокий",
    maxDuration: Duration(seconds: 60),
    maxIterations: 10,
  );
}
