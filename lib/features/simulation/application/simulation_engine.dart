import 'package:rebirth_city/features/simulation/domain/models/simulation_effects.dart';
import 'package:rebirth_city/features/simulation/domain/models/simulation_snapshot.dart';

class SimulationEngine {
  const SimulationEngine();

  SimulationSnapshot project({
    required int currentPopulation,
    required double currentElderlyRatio,
    required double currentBudgetOkuYen,
    required double currentHappinessScore,
    required double currentFinancialBalance,
    required SimulationEffects effects,
    required int yearOffset,
  }) {
    final populationFactor =
        (1 - (yearOffset * (0.006 - effects.populationDeltaRate))).clamp(0.42, 1.08);
    final elderlyFactor =
        currentElderlyRatio + (yearOffset * (0.0025 - effects.elderlyRatioDeltaRate));
    final budgetFactor =
        (1 - (yearOffset * (0.002 - effects.budgetDeltaRate))).clamp(0.7, 1.18);
    final happinessShift =
        (yearOffset * (0.08 + effects.happinessDelta * 0.015)) -
        ((elderlyFactor - currentElderlyRatio) * 12);
    final financialBalance =
        (currentFinancialBalance + (effects.budgetDeltaRate * 200) + (effects.happinessDelta * 0.6))
            .clamp(0.0, 100.0);

    return SimulationSnapshot(
      yearOffset: yearOffset,
      projectedPopulation: (currentPopulation * populationFactor).round(),
      elderlyRatio: elderlyFactor.clamp(0.0, 1.0),
      projectedBudgetOkuYen: currentBudgetOkuYen * budgetFactor,
      projectedHappinessScore:
          (currentHappinessScore + happinessShift).clamp(0.0, 100.0),
      projectedFinancialBalance: financialBalance,
      assetCirculationScore: effects.assetCirculationScore.clamp(0.0, 100.0),
    );
  }
}
