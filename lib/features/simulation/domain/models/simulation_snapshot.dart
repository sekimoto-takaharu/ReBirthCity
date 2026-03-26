class SimulationSnapshot {
  const SimulationSnapshot({
    required this.yearOffset,
    required this.projectedPopulation,
    required this.elderlyRatio,
    required this.projectedBudgetOkuYen,
    required this.projectedHappinessScore,
  });

  final int yearOffset;
  final int projectedPopulation;
  final double elderlyRatio;
  final double projectedBudgetOkuYen;
  final double projectedHappinessScore;
}
