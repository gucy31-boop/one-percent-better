import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Statisches Impressum nach § 5 TMG / § 18 MStV.
///
/// WICHTIG: Die Platzhalter in eckigen Klammern MÜSSEN vor
/// Veröffentlichung durch die echten Angaben des Betreibers
/// ersetzt werden. Ein Impressum mit Platzhaltern ist nicht
/// rechtsgültig und darf nicht veröffentlicht werden.
class ImpressumScreen extends StatelessWidget {
  const ImpressumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Impressum')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Angaben gemäß § 5 TMG',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const _InfoLine(label: 'Name', value: '[Vorname Nachname / Firmenname]'),
              const _InfoLine(label: 'Anschrift', value: '[Straße Hausnummer]\n[PLZ Ort]\n[Land]'),
              const _InfoLine(label: 'E-Mail', value: '[kontakt@beispiel.de]'),
              const SizedBox(height: 20),
              Text(
                'Verantwortlich für den Inhalt nach § 18 Abs. 2 MStV',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const _InfoLine(label: 'Name', value: '[Vorname Nachname]'),
              const _InfoLine(label: 'Anschrift', value: '[Straße Hausnummer, PLZ Ort]'),
              const SizedBox(height: 24),
              Text(
                'Diese Vorlage muss vor Veröffentlichung im Play Store mit '
                'den tatsächlichen Betreiberdaten vervollständigt werden.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withValues(alpha: 0.5),
            ),
          ),
          Text(value, style: GoogleFonts.inter(fontSize: 14.5, height: 1.4)),
        ],
      ),
    );
  }
}
