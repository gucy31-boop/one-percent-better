import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Statische Datenschutzerklärung.
///
/// Inhalt ist bewusst als Platzhalter-Vorlage zu verstehen, die vor
/// Veröffentlichung von einem Juristen bzw. anhand des tatsächlichen
/// Betreibers final geprüft/angepasst werden sollte (Name, Anschrift,
/// Kontakt-E-Mail).
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datenschutz')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Section(
                title: '1. Verantwortlicher',
                body:
                    'Verantwortlich für die Datenverarbeitung im Sinne der '
                    'DSGVO ist der im Impressum genannte Anbieter dieser App.',
              ),
              _Section(
                title: '2. Datenverarbeitung in der App',
                body:
                    '„1% Better" wurde bewusst offline-first entwickelt. '
                    'Alle Einträge, dein Streak-Stand und deine Einstellungen '
                    'werden ausschließlich lokal auf deinem Gerät gespeichert '
                    '(Hive-Datenbank). Es findet keine Übertragung dieser '
                    'Daten an Server des Anbieters statt. Es gibt kein '
                    'Nutzerkonto und keine Cloud-Synchronisierung.',
              ),
              _Section(
                title: '3. Benachrichtigungen',
                body:
                    'Die tägliche Erinnerung wird ausschließlich lokal auf '
                    'deinem Gerät geplant (lokale Push-Benachrichtigung). '
                    'Hierfür werden keine Daten an Dritte übermittelt.',
              ),
              _Section(
                title: '4. Zahlungsabwicklung (Premium)',
                body:
                    'Der Kauf des Premium-Abonnements erfolgt vollständig '
                    'über Google Play Billing. Zahlungsdaten werden von '
                    'Google verarbeitet; der App-Anbieter erhält keinen '
                    'Zugriff auf Zahlungsinformationen. Es gelten zusätzlich '
                    'die Datenschutzbestimmungen von Google.',
              ),
              _Section(
                title: '5. Keine Werbung, kein Tracking',
                body:
                    'Diese App enthält keine Werbung, keine Analyse- oder '
                    'Tracking-SDKs von Drittanbietern und sammelt keine '
                    'Nutzungsstatistiken.',
              ),
              _Section(
                title: '6. Deine Rechte',
                body:
                    'Da sämtliche Daten ausschließlich lokal auf deinem '
                    'Gerät gespeichert werden, hast du jederzeit volle '
                    'Kontrolle: Über die Deinstallation der App oder das '
                    'Löschen der App-Daten in den Android-Einstellungen '
                    'werden alle gespeicherten Informationen unwiderruflich '
                    'entfernt.',
              ),
              _Section(
                title: '7. Kontakt',
                body:
                    'Bei Fragen zum Datenschutz wende dich bitte an die im '
                    'Impressum angegebene Kontaktadresse.',
              ),
              const SizedBox(height: 12),
              Text(
                'Stand: Juli 2026',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: GoogleFonts.inter(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
