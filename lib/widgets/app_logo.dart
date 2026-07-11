import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_theme.dart';

/// Textbasiertes Logo: "1%" in Grün + "Better" in der Grundfarbe.
///
/// Kein Bild nötig – schnell, skalierbar, immer scharf.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.fontSize = 28});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).textTheme.bodyLarge?.color;
    return RichText(
      text: TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        children: [
          const TextSpan(
            text: '1% ',
            style: TextStyle(color: AppTheme.accentGreen),
          ),
          TextSpan(
            text: 'Better',
            style: TextStyle(color: baseColor),
          ),
        ],
      ),
    );
  }
}
