import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/date_utils.dart';
import '../models/daily_entry.dart';
import '../models/streak_data.dart';

/// Kapselt sämtlichen lokalen Speicherzugriff (Hive).
///
/// Dies ist die einzige Klasse, die direkt mit Hive spricht.
/// Alles andere in der App kennt nur diese Schnittstelle
/// (Clean Architecture: Data Layer isoliert vom Rest).
class StorageService {
  late final Box<DailyEntry> _entriesBox;
  late final Box _settingsBox;

  /// Muss einmalig beim App-Start aufgerufen werden.
  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DailyEntryAdapter());
    }

    _entriesBox = await Hive.openBox<DailyEntry>(AppConstants.entriesBoxName);
    _settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
  }

  // -----------------------------------------------------------------
  // Einträge
  // -----------------------------------------------------------------

  /// Speichert (oder überschreibt) den Eintrag für den heutigen Tag.
  Future<void> saveTodayEntry(String text) async {
    final today = AppDateUtils.today();
    final key = _keyForDate(today);
    await _entriesBox.put(key, DailyEntry(date: today, text: text));
  }

  /// Gibt alle Einträge zurück, neueste zuerst.
  List<DailyEntry> getAllEntries() {
    final entries = _entriesBox.values.toList();
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  /// Gibt die letzten [limit] Einträge zurück (neueste zuerst).
  List<DailyEntry> getRecentEntries({required int limit}) {
    final all = getAllEntries();
    if (all.length <= limit) return all;
    return all.sublist(0, limit);
  }

  DailyEntry? getEntryForDate(DateTime date) {
    return _entriesBox.get(_keyForDate(AppDateUtils.dateOnly(date)));
  }

  bool hasEntryForToday() {
    return getEntryForDate(AppDateUtils.today()) != null;
  }

  String _keyForDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  // -----------------------------------------------------------------
  // Streak
  // -----------------------------------------------------------------

  StreakData getStreakData() {
    final streak = _settingsBox.get(
      AppConstants.keyCurrentStreak,
      defaultValue: 0,
    ) as int;
    final lastDateString =
        _settingsBox.get(AppConstants.keyLastCompletedDate) as String?;
    final lastDate =
        lastDateString != null ? DateTime.parse(lastDateString) : null;
    return StreakData(currentStreak: streak, lastCompletedDate: lastDate);
  }

  /// Berechnet und speichert den neuen Streak-Wert nach Abschluss
  /// der heutigen Aufgabe.
  ///
  /// Logik:
  /// - War der letzte Abschluss gestern -> Streak +1
  /// - War der letzte Abschluss bereits heute -> unverändert
  /// - Sonst (Lücke von >= 2 Tagen oder erster Eintrag) -> Streak = 1
  Future<StreakData> registerCompletionForToday() async {
    final current = getStreakData();
    final today = AppDateUtils.today();

    int newStreak;
    if (current.lastCompletedDate != null &&
        AppDateUtils.isSameDay(current.lastCompletedDate!, today)) {
      newStreak = current.currentStreak;
    } else if (current.lastCompletedDate != null &&
        AppDateUtils.isSameDay(
          current.lastCompletedDate!,
          AppDateUtils.yesterday(),
        )) {
      newStreak = current.currentStreak + 1;
    } else {
      newStreak = 1;
    }

    await _settingsBox.put(AppConstants.keyCurrentStreak, newStreak);
    await _settingsBox.put(
      AppConstants.keyLastCompletedDate,
      today.toIso8601String(),
    );

    return StreakData(currentStreak: newStreak, lastCompletedDate: today);
  }

  // -----------------------------------------------------------------
  // Einstellungen
  // -----------------------------------------------------------------

  bool getDarkMode() =>
      _settingsBox.get(AppConstants.keyDarkMode, defaultValue: true) as bool;

  Future<void> setDarkMode(bool value) async =>
      _settingsBox.put(AppConstants.keyDarkMode, value);

  bool getNotificationsEnabled() => _settingsBox.get(
        AppConstants.keyNotificationsEnabled,
        defaultValue: true,
      ) as bool;

  Future<void> setNotificationsEnabled(bool value) async =>
      _settingsBox.put(AppConstants.keyNotificationsEnabled, value);

  int getNotificationHour() => _settingsBox.get(
        AppConstants.keyNotificationHour,
        defaultValue: AppConstants.defaultReminderHour,
      ) as int;

  int getNotificationMinute() => _settingsBox.get(
        AppConstants.keyNotificationMinute,
        defaultValue: AppConstants.defaultReminderMinute,
      ) as int;

  Future<void> setNotificationTime(int hour, int minute) async {
    await _settingsBox.put(AppConstants.keyNotificationHour, hour);
    await _settingsBox.put(AppConstants.keyNotificationMinute, minute);
  }

  bool getIsPremium() =>
      _settingsBox.get(AppConstants.keyIsPremium, defaultValue: false) as bool;

  Future<void> setIsPremium(bool value) async =>
      _settingsBox.put(AppConstants.keyIsPremium, value);
}
