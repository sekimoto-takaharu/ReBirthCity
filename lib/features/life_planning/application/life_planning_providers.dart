import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebirth_city/features/life_planning/domain/models/life_action.dart';

final lifeActionsProvider = Provider<List<LifeAction>>((ref) {
  return const [
    LifeAction(
      title: '空き家リノベ転換',
      description: '使われていない住居を地域交流拠点に変え、税収と交流人口を増やします。',
      type: LifeActionType.housingReuse,
    ),
    LifeAction(
      title: '相続高速道路',
      description: '相続手続きを円滑にして、資産循環の停滞を減らします。',
      type: LifeActionType.inheritance,
    ),
    LifeAction(
      title: '想い出アーカイブ',
      description: '家族へのメッセージや記録を保存し、地域の継承資産を高めます。',
      type: LifeActionType.legacyArchive,
    ),
    LifeAction(
      title: '健康投資ウォーク',
      description: '日々の歩行を健康スコアとして還元し、幸福度悪化を抑えます。',
      type: LifeActionType.wellnessWalk,
    ),
  ];
});

final selectedLifeActionTypesProvider =
    StateNotifierProvider<SelectedLifeActionTypesNotifier, Set<LifeActionType>>((ref) {
  return SelectedLifeActionTypesNotifier();
});

class SelectedLifeActionTypesNotifier extends StateNotifier<Set<LifeActionType>> {
  SelectedLifeActionTypesNotifier() : super({});

  void toggle(LifeActionType type) {
    if (state.contains(type)) {
      state = {...state}..remove(type);
      return;
    }

    state = {...state, type};
  }
}
