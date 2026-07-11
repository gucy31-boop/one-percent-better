import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../models/daily_entry.dart';
import '../models/streak_data.dart';
import 'premium_provider.dart';
import 'service_providers.dart';

/// Gesamter Zustand rund um Einträge, Verlauf und Streak.
class EntryState {
  final List<DailyEntry> recentEntries;
  final StreakData streak;
  final bool hasCompletedToday;

  const EntryState({
    required this.recentEntries,
    required this.streak,
    required this.hasCompletedToday,
  });

  static const initial = EntryState(
    recentEntries: [],
    streak: StreakData.empty,
    hasCompletedToday: false,
  );

  EntryState copyWith({
    List<DailyEntry>? recentEntries,
    StreakData? streak,
    bool? hasCompletedToday,
  }) {
    return EntryState(
      recentEntries: recentEntries ?? this.recentEntries,
      streak: streak ?? this.streak,
      hasCompletedToday: hasCompletedToday ?? this.hasCompletedToday,
    );
  }
}

class EntryNotifier extends StateNotifier<EntryState> {
  final Ref ref;

  EntryNotifier(this.ref) : super(EntryState.initial) {
    _load();
  }

  void _load() {
    final storage = ref.read(storageServiceProvider);
    final isPremium = ref.read(premiumProvider);

    final limit = isPremium ? 1 << 30 : AppConstants.freeHistoryLimit;
    final entries = storage.getRecentEntries(limit: limit);
    final streak = storage.getStreakData();

    state = state.copyWith(
      recentEntries: entries,
      streak: streak,
      hasCompletedToday: storage.hasEntryForToday(),
    );
  }

  /// Wird aufgerufen, wenn der Nutzer auf "Erledigt" tippt.
  Future<void> completeToday(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final storage = ref.read(storageServiceProvider);
    await storage.saveTodayEntry(trimmed);
    final newStreak = await storage.registerCompletionForToday();

    final isPremium = ref.read(premiumProvider);
    final limit = isPremium ? 1 << 30 : AppConstants.freeHistoryLimit;

    state = state.copyWith(
      recentEntries: storage.getRecentEntries(limit: limit),
      streak: newStreak,
      hasCompletedToday: true,
    );
  }

  void refresh() => _load();
}

final entryProvider = StateNotifierProvider<EntryNotifier, EntryState>((ref) {
  return EntryNotifier(ref);
});
