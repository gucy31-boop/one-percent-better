import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';

/// Zeigt die aktuelle Streak-Länge als kleines, ruhiges Badge.
class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key, required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (streak <= 0) {
      return Text(
        'Starte heute deine Serie',
        style: GoogleFonts.inter(
          fontSize: 14,
          color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(
                alpha: 0.6,
              ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.accentGreen.withValues(alpha: isDark ? 0.16 : 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 15)),
          const SizedBox(width: 6),
          Text(
            '$streak ${streak == 1 ? "Tag" : "Tage"} in Folge',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.accentGreen,
            ),
          ),
        ],
      ),
    );
  }
}
