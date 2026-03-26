import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebirth_city/core/theme.dart';
import 'package:rebirth_city/features/city_management/application/city_management_providers.dart';
import 'package:rebirth_city/features/simulation/application/simulation_providers.dart';

class SimulationPage extends ConsumerWidget {
  const SimulationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = ref.watch(selectedCityProvider);
    final selectedYear = ref.watch(simulationYearProvider);
    final snapshot = ref.watch(simulationSnapshotProvider);
    final timeline = ref.watch(simulationTimelineProvider);

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
            '基礎ロジックでは人口減少、高齢化、予算縮小を年次係数で試算しています。次フェーズで終活アクションの効果を反映します。',
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
