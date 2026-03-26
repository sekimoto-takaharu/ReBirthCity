import 'package:rebirth_city/features/simulation/domain/models/simulation_snapshot.dart';

class SimulationEngine {
  const SimulationEngine();

  SimulationSnapshot project({
    required int currentPopulation,
    required double currentElderlyRatio,
    required int yearOffset,
  }) {
    final populationFactor = 1 - (yearOffset * 0.006);
    final elderlyFactor = currentElderlyRatio + (yearOffset * 0.0025);

    return SimulationSnapshot(
      yearOffset: yearOffset,
      projectedPopulation: (currentPopulation * populationFactor).round(),
      elderlyRatio: elderlyFactor.clamp(0.0, 1.0),
    );
  }
}
