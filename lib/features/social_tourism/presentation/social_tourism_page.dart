import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebirth_city/core/theme.dart';
import 'package:rebirth_city/features/social_tourism/application/social_tourism_providers.dart';
import 'package:rebirth_city/features/social_tourism/domain/models/service_link.dart';
import 'package:rebirth_city/features/social_tourism/domain/models/tour_city.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialTourismPage extends ConsumerWidget {
  const SocialTourismPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tourCities = ref.watch(tourCitiesProvider);
    final serviceLinks = ref.watch(serviceLinksProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
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
              Text(
                '未来の街へ視察',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '他プレイヤーが作った未来都市を観光し、成功パターンを学びます。',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '観光ルート',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        for (final city in tourCities) ...[
          _TourCityCard(city: city),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 12),
        Text(
          '実在サービス',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        for (final link in serviceLinks) ...[
          _ServiceLinkCard(link: link),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _TourCityCard extends StatelessWidget {
  const _TourCityCard({required this.city});

  final TourCity city;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${city.prefecture} / ${city.yearOffset}年後',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(city.highlight),
                  backgroundColor: AppTheme.accentGoldSoft,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              city.summary,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _TourStat(
                    label: '幸福度',
                    value: city.happinessScore.toStringAsFixed(1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TourStat(
                    label: '財政バランス',
                    value: city.financialBalance.toStringAsFixed(1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('この未来都市を視察'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TourStat extends StatelessWidget {
  const _TourStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlueSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryBlueDeep,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceLinkCard extends StatelessWidget {
  const _ServiceLinkCard({required this.link});

  final ServiceLink link;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),
        leading: const CircleAvatar(
          backgroundColor: AppTheme.primaryBlueSoft,
          foregroundColor: AppTheme.primaryBlueDeep,
          child: Icon(Icons.open_in_new_rounded),
        ),
        title: Text(link.title),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            link.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () async {
          final uri = Uri.parse(link.url);
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
      ),
    );
  }
}
