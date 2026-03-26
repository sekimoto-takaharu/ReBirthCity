import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebirth_city/features/city_management/application/city_management_providers.dart';
import 'package:rebirth_city/features/life_planning/application/life_planning_providers.dart';
import 'package:rebirth_city/features/life_planning/domain/models/life_action.dart';
import 'package:rebirth_city/features/simulation/application/simulation_engine.dart';
import 'package:rebirth_city/features/simulation/domain/models/simulation_effects.dart';
import 'package:rebirth_city/features/simulation/domain/models/simulation_snapshot.dart';

final simulationEngineProvider = Provider<SimulationEngine>((ref) {
  return const SimulationEngine();
});

final simulationYearProvider = StateProvider<double>((ref) {
  return 30;
});

final simulationSnapshotProvider = Provider<SimulationSnapshot>((ref) {
  final city = ref.watch(selectedCityProvider);
  final yearOffset = ref.watch(simulationYearProvider).round();
  final engine = ref.watch(simulationEngineProvider);
  final effects = ref.watch(simulationEffectsProvider);

  return engine.project(
    currentPopulation: city.population,
    currentElderlyRatio: city.elderlyRatio,
    currentBudgetOkuYen: city.annualBudgetOkuYen,
    currentHappinessScore: city.happinessScore,
    currentFinancialBalance: city.financialHealth,
    effects: effects,
    yearOffset: yearOffset,
  );
});

final simulationTimelineProvider = Provider<List<SimulationSnapshot>>((ref) {
  final city = ref.watch(selectedCityProvider);
  final engine = ref.watch(simulationEngineProvider);
  final effects = ref.watch(simulationEffectsProvider);
  const milestones = [0, 10, 20, 30, 50, 100];

  return milestones
      .map(
        (yearOffset) => engine.project(
          currentPopulation: city.population,
          currentElderlyRatio: city.elderlyRatio,
          currentBudgetOkuYen: city.annualBudgetOkuYen,
          currentHappinessScore: city.happinessScore,
          currentFinancialBalance: city.financialHealth,
          effects: effects,
          yearOffset: yearOffset,
        ),
      )
      .toList();
});

final simulationEffectsProvider = Provider<SimulationEffects>((ref) {
  final selectedActions = ref.watch(selectedLifeActionTypesProvider);

  return selectedActions.fold(SimulationEffects.zero, (current, actionType) {
    return current + _effectForAction(actionType);
  });
});

SimulationEffects _effectForAction(LifeActionType type) {
  return switch (type) {
    LifeActionType.housingReuse => const SimulationEffects(
        populationDeltaRate: 0.0008,
        budgetDeltaRate: 0.0009,
        happinessDelta: 3.4,
        elderlyRatioDeltaRate: 0.0001,
        assetCirculationScore: 18,
      ),
    LifeActionType.inheritance => const SimulationEffects(
        populationDeltaRate: 0.0004,
        budgetDeltaRate: 0.0011,
        happinessDelta: 2.0,
        elderlyRatioDeltaRate: 0.0001,
        assetCirculationScore: 28,
      ),
    LifeActionType.legacyArchive => const SimulationEffects(
        populationDeltaRate: 0.0002,
        budgetDeltaRate: 0.0003,
        happinessDelta: 4.2,
        elderlyRatioDeltaRate: 0.0002,
        assetCirculationScore: 24,
      ),
    LifeActionType.wellnessWalk => const SimulationEffects(
        populationDeltaRate: 0.0005,
        budgetDeltaRate: 0.0005,
        happinessDelta: 5.1,
        elderlyRatioDeltaRate: 0.0004,
        assetCirculationScore: 14,
      ),
  };
}
