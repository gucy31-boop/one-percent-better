import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../models/daily_entry.dart';

/// Liste der letzten Einträge. Ruhig, ohne Icons-Overkill,
/// eine Zeile pro Tag.
class HistoryList extends StatelessWidget {
  const HistoryList({super.key, required this.entries});

  final List<DailyEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          'Noch keine Einträge. Fang jetzt an.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.color
                ?.withValues(alpha: 0.55),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Letzte Einträge',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.color
                ?.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 12),
        ...entries.map((entry) => _HistoryRow(entry: entry)),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

  final DailyEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Text(
              AppDateUtils.formatShort(entry.date),
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withValues(alpha: 0.45),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 10),
            decoration: const BoxDecoration(
              color: AppTheme.accentGreen,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              entry.text,
              style: GoogleFonts.inter(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
