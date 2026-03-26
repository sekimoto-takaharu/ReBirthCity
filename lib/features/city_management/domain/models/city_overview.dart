class CityOverview {
  const CityOverview({
    required this.code,
    required this.name,
    required this.population,
    required this.annualBudgetOkuYen,
    required this.elderlyRatio,
    required this.happinessScore,
    required this.financialHealth,
  });

  final String code;
  final String name;
  final int population;
  final double annualBudgetOkuYen;
  final double elderlyRatio;
  final double happinessScore;
  final double financialHealth;
}
