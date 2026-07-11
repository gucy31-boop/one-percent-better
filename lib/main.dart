import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'providers/premium_provider.dart';
import 'providers/service_providers.dart';
import 'providers/settings_provider.dart';
import 'routes/app_router.dart';
import 'services/billing_service.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Services werden hier einmalig initialisiert und danach per
  // Provider-Override an Riverpod übergeben. So bleibt main.dart
  // die einzige Stelle, die Initialisierungsreihenfolge kennen muss.
  final storageService = StorageService();
  await storageService.init();

  final notificationService = NotificationService();
  await notificationService.init();

  final billingService = BillingService(storageService: storageService);
  await billingService.init();

  // Falls die tägliche Erinnerung aktiviert ist, direkt (re-)planen –
  // z. B. nach einem Geräteneustart, der geplante Alarme löscht.
  if (storageService.getNotificationsEnabled()) {
    await notificationService.scheduleDailyReminder(
      hour: storageService.getNotificationHour(),
      minute: storageService.getNotificationMinute(),
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
        notificationServiceProvider.overrideWithValue(notificationService),
        billingServiceProvider.overrideWithValue(billingService),
      ],
      child: const OnePercentBetterApp(),
    ),
  );
}

class OnePercentBetterApp extends ConsumerStatefulWidget {
  const OnePercentBetterApp({super.key});

  @override
  ConsumerState<OnePercentBetterApp> createState() =>
      _OnePercentBetterAppState();
}

class _OnePercentBetterAppState extends ConsumerState<OnePercentBetterApp> {
  @override
  void initState() {
    super.initState();
    // Premium-Statusänderungen (nach Kauf/Wiederherstellung) live
    // in den Riverpod-State spiegeln.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final billing = ref.read(billingServiceProvider);
      billing.premiumStatusStream.listen((isPremium) {
        ref.read(premiumProvider.notifier).setPremium(isPremium);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(
      settingsProvider.select((s) => s.isDarkMode),
    );

    return MaterialApp.router(
      title: '1% Better',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
