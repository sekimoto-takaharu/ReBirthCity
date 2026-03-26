import 'package:flutter/material.dart';
import 'package:rebirth_city/core/theme.dart';
import 'package:rebirth_city/features/life_planning/domain/models/life_action.dart';

class LifePlanningPage extends StatelessWidget {
  const LifePlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    const actions = [
      LifeAction(
        title: '想い出の記録',
        description: 'カメラで書類やメッセージを残し、次世代に継承します。',
        type: LifeActionType.legacyArchive,
      ),
      LifeAction(
        title: '健康投資ウォーク',
        description: 'GPS 連動で日々の歩みを街の資産に変換します。',
        type: LifeActionType.wellnessWalk,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlueSoft,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1タップで街に貢献',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryBlueDeep,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '終活アクションを選ぶと、将来の幸福度や街の資産に反映される想定です。',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        for (final action in actions) ...[
          _ActionCard(action: action),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.action});

  final LifeAction action;

  @override
  Widget build(BuildContext context) {
    final icon = switch (action.type) {
      LifeActionType.legacyArchive => Icons.photo_camera_back_rounded,
      LifeActionType.wellnessWalk => Icons.directions_walk_rounded,
      LifeActionType.housingReuse => Icons.house_siding_rounded,
      LifeActionType.inheritance => Icons.family_restroom_rounded,
    };

    final effectLabel = switch (action.type) {
      LifeActionType.legacyArchive => '継承力 +12',
      LifeActionType.wellnessWalk => '健康投資 +8',
      LifeActionType.housingReuse => '空き家活用 +10',
      LifeActionType.inheritance => '資産循環 +9',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryBlueSoft,
                  foregroundColor: AppTheme.primaryBlueDeep,
                  child: Icon(icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    action.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Chip(
                  label: Text(effectLabel),
                  backgroundColor: AppTheme.accentGoldSoft,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              action.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('このアクションを準備'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
