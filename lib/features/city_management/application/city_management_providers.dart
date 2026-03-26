import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebirth_city/features/city_management/data/mock_city_repository.dart';
import 'package:rebirth_city/features/city_management/domain/models/city_overview.dart';

final mockCityRepositoryProvider = Provider<MockCityRepository>((ref) {
  return const MockCityRepository();
});

final cityListProvider = Provider<List<CityOverview>>((ref) {
  return ref.watch(mockCityRepositoryProvider).fetchCities();
});

final selectedCityCodeProvider = StateProvider<String>((ref) {
  final cities = ref.watch(cityListProvider);
  return cities.first.code;
});

final selectedCityProvider = Provider<CityOverview>((ref) {
  final selectedCode = ref.watch(selectedCityCodeProvider);
  final cities = ref.watch(cityListProvider);

  return cities.firstWhere((city) => city.code == selectedCode);
});
