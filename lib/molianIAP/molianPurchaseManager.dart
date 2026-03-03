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
    print('Recovering transactions');
    if (!await _purchaseService.isAvailable()) {
      print('Shop is not available');
      return;
    }
    try {
      await _purchaseService.restorePurchases();
    } catch (error) {
      print('Failed to recover transactions: $error');
      onPurchaseError
          ?.call('Failed to recover transactions: ${error.toString()}');
    }
  }

  Future<void> _setup() async {
    print('Setting up MolianPurchaseManager');
    try {
      _isShopAvailable = await _purchaseService.isAvailable();
      if (!_isShopAvailable) {
        print('Shop is not available');
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
        print('Transaction stream error: $error');
        onPurchaseError?.call('Transaction stream error: ${error.toString()}');
      });

      _isInitialized = true;
      _initCompleter.complete();
    } catch (e) {
      print('Setup error: $e');
      _initCompleter.completeError(e);
    }
  }

  void _processTransactionUpdates(List<PurchaseDetails> purchaseDetailsList) {
    print('Processing transaction updates, count: ${purchaseDetailsList.length}');
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print(
          'Transaction update for product ${purchaseDetails.productID}, status: ${purchaseDetails.status}');
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _isTransactionPending = true;
        _isTransactionInProgress = true;
        print('Transaction is pending');
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print('Transaction error detected');
          _handleTransactionError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          print('Transaction successful: ${purchaseDetails.status}');
          _transactionEventController.add(purchaseDetails.productID);
          _finalizeTransaction(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          // 用户取消了支付
          print('Transaction canceled by user');
          onPurchaseError?.call('支付已取消');
        }
        if (purchaseDetails.pendingCompletePurchase) {
          print('Completing purchase...');
          _purchaseService.completePurchase(purchaseDetails);
        }
        // 重置交易状态
        print('Resetting transaction state');
        _isTransactionPending = false;
        _isTransactionInProgress = false;
      }
    }
  }

  void _finalizeTransaction(PurchaseDetails purchaseDetails) {
    print('Finalizing transaction for ${purchaseDetails.productID}');
    int coinsToAdd = _calculateCoinsForProduct(purchaseDetails.productID);
    print('Coins to add: $coinsToAdd');
    onPurchaseComplete?.call(coinsToAdd);
  }

  void _handleTransactionError(IAPError error) {
    _isTransactionPending = false;
    _isTransactionInProgress = false;
    print('Transaction failed, error: ${error.message}, code: ${error.code}');
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

  // 重置交易状态（用于超时等情况）
  void resetTransactionState() {
    print('Manually resetting transaction state');
    _isTransactionInProgress = false;
    _isTransactionPending = false;
  }

  void dispose() {
    _transactionEventController.close();
  }

  Future<ProductDetails> getProductDetails(String id) async {
    print('Fetching product details: $id');
    await initialized; // Wait for initialization to complete
    try {
      return _availableProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      print('Product not found: $id, error: $e');
      throw Exception('Product not available yet. Please try again later.');
    }
  }

  Future<void> _fetchAvailableProducts(Set<String> productIdentifiers) async {
    final ProductDetailsResponse response =
        await _purchaseService.queryProductDetails(productIdentifiers);
    if (response.notFoundIDs.isNotEmpty) {
      print('Some products were not found: ${response.notFoundIDs.join(", ")}');
    }
    for (var product in response.productDetails) {
      print('Available product: ${product.id}, title: ${product.title}');
    }
    _availableProducts = response.productDetails;
    if (_availableProducts.isEmpty) {
      print('No available products found');
    }
  }

  int _calculateCoinsForProduct(String productIdentifier) {
    try {
      return shopInventory
          .firstWhere((bundle) => bundle.itemId == productIdentifier)
          .coinAmount;
    } catch (e) {
      print('Package not found: $productIdentifier, error: $e');
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
      print('Bundle not found: $productIdentifier, error: $e');
      return null;
    }
  }
}
