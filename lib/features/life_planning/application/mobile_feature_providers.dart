import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebirth_city/features/life_planning/data/walking_repository.dart';
import 'package:rebirth_city/features/life_planning/domain/models/memory_scan_entry.dart';
import 'package:rebirth_city/features/life_planning/domain/models/walking_progress.dart';

final memoryScanEntriesProvider =
    StateNotifierProvider<MemoryScanEntriesNotifier, List<MemoryScanEntry>>((ref) {
  return MemoryScanEntriesNotifier();
});

final legacyArchiveScoreProvider = Provider<int>((ref) {
  final entries = ref.watch(memoryScanEntriesProvider);
  return entries.fold(0, (sum, item) => sum + item.legacyPoints);
});

class MemoryScanEntriesNotifier extends StateNotifier<List<MemoryScanEntry>> {
  MemoryScanEntriesNotifier() : super(const []);

  void scanDocument() {
    final nextIndex = state.length + 1;
    final entry = MemoryScanEntry(
      title: '想い出スキャン #$nextIndex',
      scannedAt: DateTime.now(),
      legacyPoints: 12,
    );

    state = [entry, ...state];
  }
}

final walkingRepositoryProvider = Provider<WalkingRepository>((ref) {
  return const WalkingRepository();
});

final walkingProgressProvider =
    StateNotifierProvider<WalkingProgressNotifier, WalkingProgress>((ref) {
  return WalkingProgressNotifier(ref.watch(walkingRepositoryProvider));
});

class WalkingProgressNotifier extends StateNotifier<WalkingProgress> {
  WalkingProgressNotifier(this._repository) : super(WalkingProgress.empty);

  final WalkingRepository _repository;

  Future<void> syncWalking() async {
    state = await _repository.syncWalking(state);
  }
}
