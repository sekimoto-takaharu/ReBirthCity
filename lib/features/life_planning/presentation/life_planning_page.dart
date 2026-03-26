import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebirth_city/core/theme.dart';
import 'package:rebirth_city/features/life_planning/application/life_planning_providers.dart';
import 'package:rebirth_city/features/life_planning/application/mobile_feature_providers.dart';
import 'package:rebirth_city/features/life_planning/domain/models/life_action.dart';
import 'package:rebirth_city/features/life_planning/domain/models/walking_progress.dart';
import 'package:rebirth_city/features/simulation/application/simulation_providers.dart';

class LifePlanningPage extends ConsumerWidget {
  const LifePlanningPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(lifeActionsProvider);
    final selectedActions = ref.watch(selectedLifeActionTypesProvider);
    final effects = ref.watch(simulationEffectsProvider);
    final memoryEntries = ref.watch(memoryScanEntriesProvider);
    final walking = ref.watch(walkingProgressProvider);

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
        _MobileFeaturePanel(
          memoryEntriesCount: memoryEntries.length,
          legacyArchiveScore: ref.watch(legacyArchiveScoreProvider),
          walking: walking,
          onScanPressed: () {
            ref.read(memoryScanEntriesProvider.notifier).scanDocument();
          },
          onWalkPressed: () async {
            await ref.read(walkingProgressProvider.notifier).syncWalking();
          },
        ),
        const SizedBox(height: 16),
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
        if (memoryEntries.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '最近のスキャン',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          for (final entry in memoryEntries.take(3)) ...[
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppTheme.primaryBlueSoft,
                  foregroundColor: AppTheme.primaryBlueDeep,
                  child: Icon(Icons.document_scanner_rounded),
                ),
                title: Text(entry.title),
                subtitle: Text(
                  '${entry.scannedAt.month}/${entry.scannedAt.day} ${entry.scannedAt.hour}:${entry.scannedAt.minute.toString().padLeft(2, '0')}  継承力 +${entry.legacyPoints}',
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }
}

class _MobileFeaturePanel extends StatelessWidget {
  const _MobileFeaturePanel({
    required this.memoryEntriesCount,
    required this.legacyArchiveScore,
    required this.walking,
    required this.onScanPressed,
    required this.onWalkPressed,
  });

  final int memoryEntriesCount;
  final int legacyArchiveScore;
  final WalkingProgress walking;
  final VoidCallback onScanPressed;
  final Future<void> Function() onWalkPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppTheme.accentGoldSoft,
                      foregroundColor: AppTheme.primaryBlueDeep,
                      child: Icon(Icons.photo_camera_rounded),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '想い・書類スキャン',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text('$memoryEntriesCount 件'),
                      backgroundColor: AppTheme.primaryBlueSoft,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'カメラ演出で書類を取り込み、継承資産として未来予測へ反映します。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _FeatureStat(
                        label: '継承力',
                        value: '+$legacyArchiveScore',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeatureStat(
                        label: '記録済み',
                        value: '$memoryEntriesCount件',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onScanPressed,
                    icon: const Icon(Icons.center_focus_strong_rounded),
                    label: const Text('スキャン演出を再生'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppTheme.primaryBlueSoft,
                      foregroundColor: AppTheme.successGreen,
                      child: Icon(Icons.route_rounded),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '健康投資ウォーク',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text(walking.usedLiveLocation ? 'GPS' : '擬似'),
                      backgroundColor: walking.usedLiveLocation
                          ? AppTheme.accentGoldSoft
                          : AppTheme.primaryBlueSoft,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '位置情報が使える環境では GPS 連動、使えない環境では安全に擬似進行します。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _FeatureStat(
                        label: '歩数',
                        value: '${walking.stepCount}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeatureStat(
                        label: '距離',
                        value: '${walking.distanceKm.toStringAsFixed(1)}km',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeatureStat(
                        label: '回数',
                        value: '${walking.sessions}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      onWalkPressed();
                    },
                    icon: const Icon(Icons.directions_walk_rounded),
                    label: const Text('ウォークを同期'),
                  ),
                ),
              ],
            ),
          ),
        ),
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

class _FeatureStat extends StatelessWidget {
  const _FeatureStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
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
