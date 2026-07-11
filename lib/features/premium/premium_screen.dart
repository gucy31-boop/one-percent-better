import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/entry_provider.dart';
import '../../providers/premium_provider.dart';
import '../../providers/service_providers.dart';
import '../../services/pdf_export_service.dart';

/// Premium Screen: genau ein Angebot, keine Tarif-Tabelle mit
/// zehn Optionen. Ein Preis, vier Vorteile, ein Button.
class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  bool _isProcessing = false;

  Future<void> _buy() async {
    setState(() => _isProcessing = true);
    await ref.read(billingServiceProvider).buyPremium();
    if (mounted) setState(() => _isProcessing = false);
  }

  Future<void> _restore() async {
    setState(() => _isProcessing = true);
    await ref.read(billingServiceProvider).restorePurchases();
    if (mounted) setState(() => _isProcessing = false);
  }

  Future<void> _exportPdf() async {
    final entries = ref.read(entryProvider).recentEntries;
    await ref.read(pdfExportServiceProvider).exportAndShare(entries);
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(premiumProvider);
    final billing = ref.watch(billingServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isPremium ? 'Du bist Premium 🎉' : 'Mehr aus 1 % holen',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 24),
              _Benefit(
                icon: Icons.all_inclusive,
                title: 'Unbegrenzte Historie',
                description: 'Sieh deinen kompletten Verlauf, nicht nur 7 Tage.',
              ),
              _Benefit(
                icon: Icons.widgets_outlined,
                title: 'Home-Widgets',
                description: 'Dein Streak direkt auf dem Homescreen.',
              ),
              _Benefit(
                icon: Icons.picture_as_pdf_outlined,
                title: 'Export als PDF',
                description: 'Exportiere deinen Verlauf jederzeit.',
              ),
              _Benefit(
                icon: Icons.insights_outlined,
                title: 'Statistiken',
                description: 'Wochen- und Monatsübersicht deiner Fortschritte.',
              ),
              const SizedBox(height: 32),
              if (!isPremium) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _buy,
                    child: _isProcessing
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : Text('${billing.displayPrice} / Monat'),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: _isProcessing ? null : _restore,
                    child: const Text('Käufe wiederherstellen'),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Monatlich kündbar. Abwicklung über Google Play.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _exportPdf,
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('Verlauf als PDF exportieren'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.accentGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.accentGreen, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
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
        ],
      ),
    );
  }
}
