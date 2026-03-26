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

    return ListView.separated(
      itemCount: actions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final action = actions[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(action.title),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                action.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}
