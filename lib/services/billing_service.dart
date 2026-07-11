import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../core/constants/app_constants.dart';
import 'storage_service.dart';

/// Kapselt Google Play Billing für das Premium-Monatsabo.
///
/// Es gibt genau ein Produkt: [AppConstants.premiumSubscriptionId].
/// Kein Freemium-Baukasten mit mehreren Tarifen – bewusst ein einziges
/// Upgrade, das alles freischaltet.
class BillingService {
  final StorageService storageService;
  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  ProductDetails? _premiumProduct;

  final _statusController = StreamController<bool>.broadcast();

  /// Emittiert true/false, sobald sich der Premium-Status ändert.
  Stream<bool> get premiumStatusStream => _statusController.stream;

  BillingService({required this.storageService});

  Future<void> init() async {
    final available = await _iap.isAvailable();
    if (!available) return;

    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () => _subscription?.cancel(),
      onError: (_) {},
    );

    await _loadProduct();
  }

  Future<void> _loadProduct() async {
    final response = await _iap.queryProductDetails(
      {AppConstants.premiumSubscriptionId},
    );
    if (response.productDetails.isNotEmpty) {
      _premiumProduct = response.productDetails.first;
    }
  }

  ProductDetails? get premiumProduct => _premiumProduct;

  /// Formatierter Preis, z. B. "0,99 €". Fällt auf einen Default-Text
  /// zurück, falls der Store-Preis noch nicht geladen wurde.
  String get displayPrice => _premiumProduct?.price ?? '0,99 €';

  Future<void> buyPremium() async {
    final product = _premiumProduct;
    if (product == null) return;

    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await storageService.setIsPremium(true);
        _statusController.add(true);
      } else if (purchase.status == PurchaseStatus.canceled ||
          purchase.status == PurchaseStatus.error) {
        _statusController.add(storageService.getIsPremium());
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}
