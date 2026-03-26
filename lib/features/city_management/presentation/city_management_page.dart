import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebirth_city/core/theme.dart';
import 'package:rebirth_city/features/city_management/application/city_management_providers.dart';
import 'package:rebirth_city/features/simulation/application/simulation_providers.dart';

class CityManagementPage extends ConsumerWidget {
  const CityManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = ref.watch(selectedCityProvider);
    final cities = ref.watch(cityListProvider);
    final selectedCode = ref.watch(selectedCityCodeProvider);
    final snapshot = ref.watch(simulationSnapshotProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.heroGradient,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '今日の運営都市',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    city.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '人口・予算・高齢化率のモックデータを基に、街の運営方針を設計します。',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCode,
                    dropdownColor: AppTheme.surfaceWhite,
                    decoration: const InputDecoration(
                      labelText: '自治体モックデータ',
                    ),
                    items: cities
                        .map(
                          (item) => DropdownMenuItem(
                            value: item.code,
                            child: Text(item.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      ref.read(selectedCityCodeProvider.notifier).state = value;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final compactWidth = (constraints.maxWidth - 12) / 2;

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _MetricCard(
                      width: compactWidth,
                      label: '人口',
                      value: _formatPopulation(city.population),
                    ),
                    _MetricCard(
                      width: compactWidth,
                      label: '予算規模',
                      value: '${city.annualBudgetOkuYen.toStringAsFixed(1)} 億円',
                    ),
                    _MetricCard(
                      width: compactWidth,
                      label: '高齢化率',
                      value: '${(city.elderlyRatio * 100).toStringAsFixed(1)}%',
                    ),
                    _MetricCard(
                      width: compactWidth,
                      label: '幸福度',
                      value: city.happinessScore.toStringAsFixed(1),
                    ),
                    _MetricCard(
                      width: compactWidth,
                      label: '財政健全度',
                      value: city.financialHealth.toStringAsFixed(1),
                    ),
                    _MetricCard(
                      width: compactWidth,
                      label: '未来幸福度',
                      value: snapshot.projectedHappinessScore.toStringAsFixed(1),
                    ),
                    _MetricCard(
                      width: compactWidth,
                      label: '未来財政',
                      value: snapshot.projectedFinancialBalance.toStringAsFixed(1),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '街のリアルタイム変化',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    _PhaseItem(
                      text: '終活コマンド反映後の幸福度: ${snapshot.projectedHappinessScore.toStringAsFixed(1)}',
                    ),
                    _PhaseItem(
                      text: '終活コマンド反映後の財政バランス: ${snapshot.projectedFinancialBalance.toStringAsFixed(1)}',
                    ),
                    _PhaseItem(
                      text: '資産循環スコア: ${snapshot.assetCirculationScore.toStringAsFixed(0)}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '現在は鎌倉市・藤沢市・横須賀市のモックデータを搭載しています。',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
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
}

class _PhaseItem extends StatelessWidget {
  const _PhaseItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.check_circle,
              size: 18,
              color: AppTheme.accentGold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
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
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
