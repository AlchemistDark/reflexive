/// Defines the reasons why the reflection loop might terminate.
enum StoppedReason {
  /// The maximum allocated time was reached.
  timeout,

  /// The Critic found no further issues (explicit "NO_ISSUES").
  noIssues,

  /// The user manually cancelled the process.
  userCancelled,

  /// The maximum number of allowed iterations was reached.
  maxIterations,

  /// The Generator failed to produce a different/better response than before.
  noImprovement,
}
