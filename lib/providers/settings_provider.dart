import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'service_providers.dart';

class SettingsState {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final int notificationHour;
  final int notificationMinute;

  const SettingsState({
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.notificationHour,
    required this.notificationMinute,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    int? notificationHour,
    int? notificationMinute,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final Ref ref;

  SettingsNotifier(this.ref)
      : super(
          SettingsState(
            isDarkMode: ref.read(storageServiceProvider).getDarkMode(),
            notificationsEnabled:
                ref.read(storageServiceProvider).getNotificationsEnabled(),
            notificationHour:
                ref.read(storageServiceProvider).getNotificationHour(),
            notificationMinute:
                ref.read(storageServiceProvider).getNotificationMinute(),
          ),
        );

  Future<void> toggleDarkMode(bool value) async {
    await ref.read(storageServiceProvider).setDarkMode(value);
    state = state.copyWith(isDarkMode: value);
  }

  Future<void> toggleNotifications(bool value) async {
    final storage = ref.read(storageServiceProvider);
    final notifications = ref.read(notificationServiceProvider);

    await storage.setNotificationsEnabled(value);
    if (value) {
      await notifications.scheduleDailyReminder(
        hour: state.notificationHour,
        minute: state.notificationMinute,
      );
    } else {
      await notifications.cancelDailyReminder();
    }
    state = state.copyWith(notificationsEnabled: value);
  }

  Future<void> setNotificationTime(int hour, int minute) async {
    final storage = ref.read(storageServiceProvider);
    final notifications = ref.read(notificationServiceProvider);

    await storage.setNotificationTime(hour, minute);
    state = state.copyWith(notificationHour: hour, notificationMinute: minute);

    if (state.notificationsEnabled) {
      await notifications.scheduleDailyReminder(hour: hour, minute: minute);
    }
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref);
});
