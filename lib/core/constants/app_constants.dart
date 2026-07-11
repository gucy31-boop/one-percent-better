/// Zentrale Konstanten der App.
///
/// Bewusst an einem Ort gesammelt, damit Texte, Keys und Limits
/// nicht über die Codebasis verstreut sind (Single Source of Truth).
library;

class AppConstants {
  AppConstants._();

  // ---------------------------------------------------------------------
  // App-Metadaten
  // ---------------------------------------------------------------------
  static const String appName = '1% Better';
  static const String appTagline = 'Heute 1 % besser werden.';

  // ---------------------------------------------------------------------
  // Hive Box- und Key-Namen
  // ---------------------------------------------------------------------
  static const String entriesBoxName = 'entries_box';
  static const String settingsBoxName = 'settings_box';

  static const String keyDarkMode = 'dark_mode';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyNotificationHour = 'notification_hour';
  static const String keyNotificationMinute = 'notification_minute';
  static const String keyIsPremium = 'is_premium';
  static const String keyCurrentStreak = 'current_streak';
  static const String keyLastCompletedDate = 'last_completed_date';

  // ---------------------------------------------------------------------
  // Limits
  // ---------------------------------------------------------------------
  /// Kostenlose Nutzer sehen nur die letzten 7 Einträge.
  static const int freeHistoryLimit = 7;

  // ---------------------------------------------------------------------
  // Benachrichtigungen
  // ---------------------------------------------------------------------
  static const int dailyReminderNotificationId = 100;
  static const String reminderTitle = 'Heute wieder 1 % besser?';
  static const String reminderBody =
      'Eine kleine Handlung reicht. Trag sie jetzt ein.';
  static const int defaultReminderHour = 19;
  static const int defaultReminderMinute = 0;

  // ---------------------------------------------------------------------
  // In-App-Kauf
  // ---------------------------------------------------------------------
  static const String premiumSubscriptionId = 'one_percent_better_premium_monthly';

  // ---------------------------------------------------------------------
  // Beispiel-Vorschläge im Eingabefeld
  // ---------------------------------------------------------------------
  static const List<String> exampleSuggestions = [
    '10 Minuten lesen',
    '20 Liegestütze',
    '1 E-Mail beantworten',
    'Zimmer aufräumen',
  ];
}
