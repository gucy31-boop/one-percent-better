import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/billing_service.dart';
import '../services/notification_service.dart';
import '../services/pdf_export_service.dart';
import '../services/storage_service.dart';

/// Diese Provider werden in main.dart nach der Initialisierung
/// mit ihren echten (bereits initialisierten) Instanzen überschrieben
/// (`overrides:` in ProviderScope). So bleibt Riverpod die einzige
/// Quelle der Wahrheit, ohne Singletons/Locator-Pattern zu benötigen.

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('storageServiceProvider muss überschrieben werden');
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError(
    'notificationServiceProvider muss überschrieben werden',
  );
});

final billingServiceProvider = Provider<BillingService>((ref) {
  throw UnimplementedError('billingServiceProvider muss überschrieben werden');
});

final pdfExportServiceProvider = Provider<PdfExportService>((ref) {
  return PdfExportService();
});
