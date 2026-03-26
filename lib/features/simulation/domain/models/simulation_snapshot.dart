class SimulationSnapshot {
  const SimulationSnapshot({
    required this.yearOffset,
    required this.projectedPopulation,
    required this.elderlyRatio,
    required this.projectedBudgetOkuYen,
    required this.projectedHappinessScore,
    required this.projectedFinancialBalance,
    required this.assetCirculationScore,
  });

  final int yearOffset;
  final int projectedPopulation;
  final double elderlyRatio;
  final double projectedBudgetOkuYen;
  final double projectedHappinessScore;
  final double projectedFinancialBalance;
  final double assetCirculationScore;
}
