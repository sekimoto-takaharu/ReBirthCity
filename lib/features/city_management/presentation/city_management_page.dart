import 'package:flutter/material.dart';
import 'package:rebirth_city/core/theme.dart';
import 'package:rebirth_city/features/city_management/domain/models/city_overview.dart';

class CityManagementPage extends StatelessWidget {
  const CityManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    const city = CityOverview(
      name: 'RE:BIRTH CITY',
      population: 128000,
      happinessScore: 74.5,
      financialHealth: 81.0,
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              city.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '市民の未来を明るく設計するための基盤画面です。',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _MetricCard(label: '人口', value: '128,000'),
                _MetricCard(label: '幸福度', value: '74.5'),
                _MetricCard(label: '財政健全度', value: '81.0'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
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
