import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/entry_provider.dart';
import '../../providers/premium_provider.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/confetti_overlay.dart';
import 'widgets/entry_input.dart';
import 'widgets/history_list.dart';
import 'widgets/streak_badge.dart';

/// Der einzige Kern-Screen der App.
///
/// Zeigt: Logo, Streak, Eingabefeld, "Erledigt"-Button, Verlauf.
/// Bewusst nichts weiter – jede zusätzliche Fläche würde vom
/// einen Zweck der App ablenken.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _controller = TextEditingController();
  late final ConfettiController _confettiController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _handleComplete() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSaving) return;

    setState(() => _isSaving = true);
    await ref.read(entryProvider.notifier).completeToday(text);
    _confettiController.play();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Stark. Du bist heute 1 % besser geworden.',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final entryState = ref.watch(entryProvider);
    final isPremium = ref.watch(premiumProvider);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppLogo(),
                      IconButton(
                        onPressed: () => context.push('/settings'),
                        icon: const Icon(Icons.settings_outlined),
                        tooltip: 'Einstellungen',
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    AppConstants.appTagline,
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StreakBadge(streak: entryState.streak.currentStreak),
                  const SizedBox(height: 40),
                  EntryInput(
                    controller: _controller,
                    enabled: !entryState.hasCompletedToday,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: entryState.hasCompletedToday || _isSaving
                          ? null
                          : _handleComplete,
                      child: Text(
                        entryState.hasCompletedToday
                            ? 'Erledigt ✓'
                            : 'Erledigt',
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Divider(),
                  const SizedBox(height: 24),
                  HistoryList(entries: entryState.recentEntries),
                  if (!isPremium) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.push('/premium'),
                      child: Text(
                        'Nur letzte 7 Tage sichtbar · Premium für unbegrenzten Verlauf',
                        style: GoogleFonts.inter(fontSize: 12.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ConfettiOverlay(controller: _confettiController),
          ),
        ],
      ),
    );
  }
}
