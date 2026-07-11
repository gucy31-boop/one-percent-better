/// Repräsentiert den aktuellen Streak-Status des Nutzers.
class StreakData {
  final int currentStreak;
  final DateTime? lastCompletedDate;

  const StreakData({
    required this.currentStreak,
    required this.lastCompletedDate,
  });

  static const empty = StreakData(currentStreak: 0, lastCompletedDate: null);

  StreakData copyWith({
    int? currentStreak,
    DateTime? lastCompletedDate,
  }) {
    return StreakData(
      currentStreak: currentStreak ?? this.currentStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }
}
