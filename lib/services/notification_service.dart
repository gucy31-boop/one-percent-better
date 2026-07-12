import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../core/constants/app_constants.dart';

/// Kapselt alles rund um lokale Push-Benachrichtigungen.
///
/// Es gibt genau eine Benachrichtigungsart: die tägliche Erinnerung.
/// Keine weiteren Notification-Kanäle, keine Sonderfälle.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);

    // Android 13+ benötigt eine explizite Laufzeit-Berechtigung.
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  /// Plant die tägliche Erinnerung zur angegebenen Uhrzeit.
  /// Ersetzt automatisch eine zuvor geplante Erinnerung.
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    await cancelDailyReminder();

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Tägliche Erinnerung',
      channelDescription: 'Erinnert dich einmal täglich an dein 1 % Ziel.',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFF22C55E),
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      AppConstants.dailyReminderNotificationId,
      AppConstants.reminderTitle,
      AppConstants.reminderBody,
      _nextInstanceOfTime(hour, minute),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(AppConstants.dailyReminderNotificationId);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
