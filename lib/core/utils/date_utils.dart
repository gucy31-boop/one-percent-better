/// Hilfsfunktionen rund um Datum/Zeit.
///
/// Wichtig: Streaks werden ausschließlich über Kalendertage (ohne Uhrzeit)
/// berechnet, damit es keine Zeitzonen- oder Uhrzeit-Randfälle gibt.
class AppDateUtils {
  AppDateUtils._();

  /// Reduziert ein DateTime auf den reinen Kalendertag (00:00:00 lokal).
  static DateTime dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static DateTime today() => dateOnly(DateTime.now());

  static DateTime yesterday() => dateOnly(
        DateTime.now().subtract(const Duration(days: 1)),
      );

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Formatiert ein Datum als "TT.MM." für die Verlaufsliste.
  static String formatShort(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.';
  }

  static String formatFull(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }
}
