import 'package:rebirth_city/features/simulation/domain/models/simulation_snapshot.dart';

class SimulationEngine {
  const SimulationEngine();

  SimulationSnapshot project({
    required int currentPopulation,
    required double currentElderlyRatio,
    required double currentBudgetOkuYen,
    required double currentHappinessScore,
    required int yearOffset,
  }) {
    final populationFactor = (1 - (yearOffset * 0.006)).clamp(0.42, 1.0);
    final elderlyFactor = currentElderlyRatio + (yearOffset * 0.0025);
    final budgetFactor = (1 - (yearOffset * 0.002)).clamp(0.7, 1.0);
    final happinessShift = (yearOffset * 0.08) - ((elderlyFactor - currentElderlyRatio) * 12);

    return SimulationSnapshot(
      yearOffset: yearOffset,
      projectedPopulation: (currentPopulation * populationFactor).round(),
      elderlyRatio: elderlyFactor.clamp(0.0, 1.0),
      projectedBudgetOkuYen: currentBudgetOkuYen * budgetFactor,
      projectedHappinessScore:
          (currentHappinessScore + happinessShift).clamp(0.0, 100.0),
    );
  }
}
