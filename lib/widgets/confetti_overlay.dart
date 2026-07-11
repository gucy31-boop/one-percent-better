import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Sehr dezenter Konfetti-Effekt für den Moment des "Erledigt".
///
/// Bewusst kurz (1,2 Sekunden), wenige Partikel, keine grellen Farben.
class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({super.key, required this.controller});

  final ConfettiController controller;

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: widget.controller,
          blastDirection: pi / 2,
          maxBlastForce: 6,
          minBlastForce: 2,
          emissionFrequency: 0.06,
          numberOfParticles: 14,
          gravity: 0.25,
          shouldLoop: false,
          colors: const [
            AppTheme.accentGreen,
            Colors.white,
            Colors.black26,
          ],
        ),
      ),
    );
  }
}
