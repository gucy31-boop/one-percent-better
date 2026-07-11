import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'service_providers.dart';

/// Reaktiver Premium-Status. Wird bei App-Start aus dem Storage
/// geladen und bei erfolgreichem Kauf über den [BillingService]-Stream
/// aktualisiert (siehe main.dart Listener-Setup).
class PremiumNotifier extends StateNotifier<bool> {
  final Ref ref;

  PremiumNotifier(this.ref)
      : super(ref.read(storageServiceProvider).getIsPremium());

  void setPremium(bool value) => state = value;
}

final premiumProvider = StateNotifierProvider<PremiumNotifier, bool>((ref) {
  return PremiumNotifier(ref);
});
