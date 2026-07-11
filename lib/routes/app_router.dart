import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/legal/impressum_screen.dart';
import '../features/legal/privacy_screen.dart';
import '../features/premium/premium_screen.dart';
import '../features/settings/settings_screen.dart';

/// Zentrale Routing-Konfiguration.
///
/// Bewusst flach: keine verschachtelten Shell-Routes, keine Tabs.
/// Die App besteht im Kern aus genau zwei Screens (Home, Settings)
/// plus drei einfachen Unterseiten.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/premium',
      name: 'premium',
      builder: (context, state) => const PremiumScreen(),
    ),
    GoRoute(
      path: '/privacy',
      name: 'privacy',
      builder: (context, state) => const PrivacyScreen(),
    ),
    GoRoute(
      path: '/impressum',
      name: 'impressum',
      builder: (context, state) => const ImpressumScreen(),
    ),
  ],
);
