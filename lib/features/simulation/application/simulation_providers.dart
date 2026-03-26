import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebirth_city/features/city_management/application/city_management_providers.dart';
import 'package:rebirth_city/features/simulation/application/simulation_engine.dart';
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

  return engine.project(
    currentPopulation: city.population,
    currentElderlyRatio: city.elderlyRatio,
    currentBudgetOkuYen: city.annualBudgetOkuYen,
    currentHappinessScore: city.happinessScore,
    yearOffset: yearOffset,
  );
});

final simulationTimelineProvider = Provider<List<SimulationSnapshot>>((ref) {
  final city = ref.watch(selectedCityProvider);
  final engine = ref.watch(simulationEngineProvider);
  const milestones = [0, 10, 20, 30, 50, 100];

  return milestones
      .map(
        (yearOffset) => engine.project(
          currentPopulation: city.population,
          currentElderlyRatio: city.elderlyRatio,
          currentBudgetOkuYen: city.annualBudgetOkuYen,
          currentHappinessScore: city.happinessScore,
          yearOffset: yearOffset,
        ),
      )
      .toList();
});
