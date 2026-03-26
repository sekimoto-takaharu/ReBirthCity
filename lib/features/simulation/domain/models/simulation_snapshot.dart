class SimulationSnapshot {
  const SimulationSnapshot({
    required this.yearOffset,
    required this.projectedPopulation,
    required this.elderlyRatio,
  });

  final int yearOffset;
  final int projectedPopulation;
  final double elderlyRatio;
}
