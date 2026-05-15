import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'molianPurchaseBundle.dart';

class MolianPurchaseManager {
  bool _isTransactionInProgress = false;
  static MolianPurchaseManager? _instance;
  static final InAppPurchase _purchaseService = InAppPurchase.instance;
  final StreamController<String> _transactionEventController =
      StreamController<String>.broadcast();
  Function(int coinsAdded)? onPurchaseComplete;
  Function(String error)? onPurchaseError;

  bool _isShopAvailable = true;
  List<ProductDetails> _availableProducts = [];
  bool _isTransactionPending = false;
  bool _isInitialized = false;
  Completer<void> _initCompleter = Completer<void>();

  MolianPurchaseManager._internal() {
    _setup();
  }

  static MolianPurchaseManager get instance {
    _instance ??= MolianPurchaseManager._internal();
    return _instance!;
  }

  bool get isTransactionInProgress => _isTransactionInProgress;
  bool get isInitialized => _isInitialized;
  Future<void> get initialized => _initCompleter.future;

  Future<void> recoverTransactions() async {
    if (!await _purchaseService.isAvailable()) {
      return;
    }
    try {
      await _purchaseService.restorePurchases();
    } catch (error) {
      onPurchaseError
          ?.call('Failed to recover transactions: ${error.toString()}');
    }
  }

  Future<void> _setup() async {
    try {
      _isShopAvailable = await _purchaseService.isAvailable();
      if (!_isShopAvailable) {
        _initCompleter.complete();
        return;
      }

      final Set<String> _productIdentifiers = Set<String>.from(
          shopInventory.map((bundle) => bundle.itemId).toList());

      await _fetchAvailableProducts(_productIdentifiers);

      _purchaseService.purchaseStream.listen(_processTransactionUpdates,
          onDone: () {
        _isTransactionPending = false;
      }, onError: (error) {
        onPurchaseError?.call('Transaction stream error: ${error.toString()}');
      });

      _isInitialized = true;
      _initCompleter.complete();
    } catch (e) {
      _initCompleter.completeError(e);
    }
  }

  void _processTransactionUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _isTransactionPending = true;
        _isTransactionInProgress = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleTransactionError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _transactionEventController.add(purchaseDetails.productID);
          _finalizeTransaction(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          onPurchaseError?.call('支付已取消');
        }
        if (purchaseDetails.pendingCompletePurchase) {
          _purchaseService.completePurchase(purchaseDetails);
        }
        _isTransactionPending = false;
        _isTransactionInProgress = false;
      }
    }
  }

  void _finalizeTransaction(PurchaseDetails purchaseDetails) {
    int coinsToAdd = _calculateCoinsForProduct(purchaseDetails.productID);
    onPurchaseComplete?.call(coinsToAdd);
  }

  void _handleTransactionError(IAPError error) {
    _isTransactionPending = false;
    _isTransactionInProgress = false;
    onPurchaseError?.call("Transaction failed: ${error.message}");
  }

  Future<void> initiateTransaction(ProductDetails product) async {
    await initialized; // Wait for initialization to complete

    // Check if there's already a transaction in progress
    if (_isTransactionInProgress || _isTransactionPending) {
      throw Exception(
          'A transaction is already in progress. Please wait for it to complete.');
    }

    try {
      _isTransactionInProgress = true;
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      await _purchaseService.buyConsumable(
          purchaseParam: purchaseParam, autoConsume: true);
    } catch (e) {
      _isTransactionInProgress = false;
      _isTransactionPending = false;
      throw Exception('Failed to initiate purchase: ${e.toString()}');
    }
  }

  void resetTransactionState() {
    _isTransactionInProgress = false;
    _isTransactionPending = false;
  }

  void dispose() {
    _transactionEventController.close();
  }

  Future<ProductDetails> getProductDetails(String id) async {
    await initialized;
    try {
      return _availableProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      throw Exception('Product not available yet. Please try again later.');
    }
  }

  Future<void> _fetchAvailableProducts(Set<String> productIdentifiers) async {
    final ProductDetailsResponse response =
        await _purchaseService.queryProductDetails(productIdentifiers);
    _availableProducts = response.productDetails;
  }

  int _calculateCoinsForProduct(String productIdentifier) {
    try {
      return shopInventory
          .firstWhere((bundle) => bundle.itemId == productIdentifier)
          .coinAmount;
    } catch (e) {
      return 0;
    }
  }

  List<MolianPurchaseBundle> getAvailableBundles() {
    return shopInventory;
  }

  MolianPurchaseBundle? findBundleById(String productIdentifier) {
    try {
      return shopInventory.firstWhere(
        (bundle) => bundle.itemId == productIdentifier,
      );
    } catch (e) {
      return null;
    }
  }
}
