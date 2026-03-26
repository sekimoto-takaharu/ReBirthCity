class SimulationEffects {
  const SimulationEffects({
    required this.populationDeltaRate,
    required this.budgetDeltaRate,
    required this.happinessDelta,
    required this.elderlyRatioDeltaRate,
    required this.assetCirculationScore,
  });

  static const zero = SimulationEffects(
    populationDeltaRate: 0,
    budgetDeltaRate: 0,
    happinessDelta: 0,
    elderlyRatioDeltaRate: 0,
    assetCirculationScore: 0,
  );

  final double populationDeltaRate;
  final double budgetDeltaRate;
  final double happinessDelta;
  final double elderlyRatioDeltaRate;
  final double assetCirculationScore;

  SimulationEffects operator +(SimulationEffects other) {
    return SimulationEffects(
      populationDeltaRate: populationDeltaRate + other.populationDeltaRate,
      budgetDeltaRate: budgetDeltaRate + other.budgetDeltaRate,
      happinessDelta: happinessDelta + other.happinessDelta,
      elderlyRatioDeltaRate: elderlyRatioDeltaRate + other.elderlyRatioDeltaRate,
      assetCirculationScore: assetCirculationScore + other.assetCirculationScore,
    );
  }
}
