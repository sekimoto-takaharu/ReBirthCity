import 'package:rebirth_city/features/city_management/domain/models/city_overview.dart';

class MockCityRepository {
  const MockCityRepository();

  List<CityOverview> fetchCities() {
    return const [
      CityOverview(
        code: 'kamakura',
        name: '鎌倉市',
        population: 172158,
        annualBudgetOkuYen: 723.4,
        elderlyRatio: 0.318,
        happinessScore: 74.5,
        financialHealth: 81.0,
      ),
      CityOverview(
        code: 'fujisawa',
        name: '藤沢市',
        population: 445172,
        annualBudgetOkuYen: 1804.2,
        elderlyRatio: 0.257,
        happinessScore: 77.2,
        financialHealth: 79.3,
      ),
      CityOverview(
        code: 'yokosuka',
        name: '横須賀市',
        population: 377753,
        annualBudgetOkuYen: 1758.8,
        elderlyRatio: 0.303,
        happinessScore: 69.1,
        financialHealth: 73.8,
      ),
    ];
  }
}
