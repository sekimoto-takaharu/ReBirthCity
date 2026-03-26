import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebirth_city/core/theme.dart';
import 'package:rebirth_city/features/life_planning/application/life_planning_providers.dart';
import 'package:rebirth_city/features/life_planning/domain/models/life_action.dart';
import 'package:rebirth_city/features/simulation/application/simulation_providers.dart';

class LifePlanningPage extends ConsumerWidget {
  const LifePlanningPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(lifeActionsProvider);
    final selectedActions = ref.watch(selectedLifeActionTypesProvider);
    final effects = ref.watch(simulationEffectsProvider);

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
                '終活コマンドを選ぶと、幸福度・財政バランス・資産循環がリアルタイムに変化します。',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _StatusChip(
                  label: '幸福度補正',
                  value: '+${effects.happinessDelta.toStringAsFixed(1)}',
                ),
                _StatusChip(
                  label: '財政補正',
                  value: '+${(effects.budgetDeltaRate * 1000).toStringAsFixed(1)}',
                ),
                _StatusChip(
                  label: '資産循環',
                  value: effects.assetCirculationScore.toStringAsFixed(0),
                ),
                _StatusChip(
                  label: '選択中',
                  value: '${selectedActions.length}件',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (final action in actions) ...[
          _ActionCard(
            action: action,
            isSelected: selectedActions.contains(action.type),
            onPressed: () {
              ref.read(selectedLifeActionTypesProvider.notifier).toggle(action.type);
            },
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.action,
    required this.isSelected,
    required this.onPressed,
  });

  final LifeAction action;
  final bool isSelected;
  final VoidCallback onPressed;

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
      color: isSelected ? AppTheme.primaryBlueSoft : null,
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
                  backgroundColor:
                      isSelected ? AppTheme.accentGold : AppTheme.accentGoldSoft,
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
                onPressed: onPressed,
                child: Text(isSelected ? 'コマンド解除' : 'このコマンドを実行'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
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
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryBlueDeep,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
