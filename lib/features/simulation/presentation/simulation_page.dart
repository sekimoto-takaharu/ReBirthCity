import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebirth_city/core/theme.dart';
import 'package:rebirth_city/features/city_management/application/city_management_providers.dart';
import 'package:rebirth_city/features/life_planning/application/life_planning_providers.dart';
import 'package:rebirth_city/features/simulation/application/simulation_providers.dart';

class SimulationPage extends ConsumerWidget {
  const SimulationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = ref.watch(selectedCityProvider);
    final selectedYear = ref.watch(simulationYearProvider);
    final snapshot = ref.watch(simulationSnapshotProvider);
    final timeline = ref.watch(simulationTimelineProvider);
    final selectedActions = ref.watch(selectedLifeActionTypesProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${city.name}の未来観測',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '親指でスライドして未来の街を確認',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '予測年数: ${selectedYear.round()} 年後',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _FutureCityVisual(
                    yearOffset: selectedYear.round(),
                    happinessScore: snapshot.projectedHappinessScore,
                    financialBalance: snapshot.projectedFinancialBalance,
                    activatedActionCount: selectedActions.length,
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: selectedYear,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: '${selectedYear.round()}年',
                    onChanged: (value) {
                      ref.read(simulationYearProvider.notifier).state = value;
                    },
                  ),
                  const SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final compactWidth = (constraints.maxWidth - 12) / 2;

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _ForecastCard(
                            width: compactWidth,
                            label: '推計人口',
                            value: _formatPopulation(snapshot.projectedPopulation),
                          ),
                          _ForecastCard(
                            width: compactWidth,
                            label: '高齢化率',
                            value: _formatPercent(snapshot.elderlyRatio),
                          ),
                          _ForecastCard(
                            width: compactWidth,
                            label: '予算規模',
                            value: '${snapshot.projectedBudgetOkuYen.toStringAsFixed(1)} 億円',
                          ),
                          _ForecastCard(
                            width: compactWidth,
                            label: '幸福度',
                            value: snapshot.projectedHappinessScore.toStringAsFixed(1),
                          ),
                          _ForecastCard(
                            width: compactWidth,
                            label: '財政バランス',
                            value: snapshot.projectedFinancialBalance.toStringAsFixed(1),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '人口推移シミュレーション',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 100,
                        minY: 0,
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 52,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${(value / 1000).round()}k',
                                  style: Theme.of(context).textTheme.labelSmall,
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    '${value.toInt()}y',
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: timeline
                                .map(
                                  (item) => FlSpot(
                                    item.yearOffset.toDouble(),
                                    item.projectedPopulation.toDouble(),
                                  ),
                                )
                                .toList(),
                            color: AppTheme.primaryBlue,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '終活コマンドの選択内容に応じて、幸福度・財政バランス・街の見た目がリアルタイムに変化します。',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatPopulation(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      final position = digits.length - i;
      buffer.write(digits[i]);
      if (position > 1 && position % 3 == 1) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }

  static String _formatPercent(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }
}

class _ForecastCard extends StatelessWidget {
  const _ForecastCard({
    required this.width,
    required this.label,
    required this.value,
  });

  final double width;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FutureCityVisual extends StatelessWidget {
  const _FutureCityVisual({
    required this.yearOffset,
    required this.happinessScore,
    required this.financialBalance,
    required this.activatedActionCount,
  });

  final int yearOffset;
  final double happinessScore;
  final double financialBalance;
  final int activatedActionCount;

  @override
  Widget build(BuildContext context) {
    final vitality = ((happinessScore + financialBalance) / 200).clamp(0.0, 1.0);
    final skylineHeight = 76 + (vitality * 44);
    final treeScale = 0.7 + (activatedActionCount * 0.08);
    final skyColor = Color.lerp(
      const Color(0xFFE8E3B6),
      const Color(0xFFCFEA8B),
      vitality,
    )!;

    return Container(
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            skyColor,
            Colors.white,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Chip(
              label: Text('$yearOffset年後'),
              backgroundColor: Colors.white.withValues(alpha: 0.72),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BuildingBar(height: skylineHeight * 0.74),
                _BuildingBar(height: skylineHeight),
                _TreeIcon(scale: treeScale),
                _BuildingBar(height: skylineHeight * 0.88),
                _TreeIcon(scale: treeScale * 0.9),
                _BuildingBar(height: skylineHeight * 0.64),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildingBar extends StatelessWidget {
  const _BuildingBar({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.primaryBlueDeep.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _TreeIcon extends StatelessWidget {
  const _TreeIcon({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: const Icon(
        Icons.park_rounded,
        size: 38,
        color: AppTheme.successGreen,
      ),
    );
  }
}
