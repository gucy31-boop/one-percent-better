import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';

/// Textfeld inkl. tippbarer Beispiel-Vorschläge.
///
/// Vorschläge sind bewusst nur "Inspiration", keine Kategorien-Auswahl –
/// ein Tap füllt einfach das Textfeld.
class EntryInput extends StatelessWidget {
  const EntryInput({
    super.key,
    required this.controller,
    required this.enabled,
  });

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final mutedColor = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.color
        ?.withValues(alpha: 0.55);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          enabled: enabled,
          maxLength: 80,
          maxLines: 2,
          minLines: 1,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: 'Was machst du heute 1 % besser?',
            counterText: '',
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.exampleSuggestions.map((suggestion) {
            return _SuggestionChip(
              label: suggestion,
              enabled: enabled,
              onTap: () => controller.text = suggestion,
            );
          }).toList(),
        ),
        if (!enabled) ...[
          const SizedBox(height: 12),
          Text(
            'Für heute bereits erledigt ✓',
            style: GoogleFonts.inter(fontSize: 13, color: mutedColor),
          ),
        ],
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    required this.label,
    required this.onTap,
    required this.enabled,
  });

  final String label;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Material(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
