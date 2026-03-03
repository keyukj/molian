import 'package:flutter/material.dart';
import 'dart:async';
import 'molianPurchaseManager.dart';
import 'molianPurchaseBundle.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../user_manager.dart';

class MolianStoreView extends StatefulWidget {
  const MolianStoreView({Key? key}) : super(key: key);

  @override
  _MolianStoreViewState createState() => _MolianStoreViewState();
}

class _MolianStoreViewState extends State<MolianStoreView>
    with SingleTickerProviderStateMixin {
  final UserManager _userManager = UserManager();
  final MolianPurchaseManager _shopManager = MolianPurchaseManager.instance;
  late List<MolianPurchaseBundle> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;
  String? _processingProductId; // 记录正在处理的商品ID
  Timer? _purchaseTimeout; // 购买超时计时器

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    
    print('Initializing MolianStoreView');
    print('Current user coins: ${_userManager.coins}');
    
    // 设置购买回调
    _shopManager.onPurchaseComplete = _handlePurchaseSuccess;
    _shopManager.onPurchaseError = _handlePurchaseFailure;
    
    print('Purchase callbacks set');
    
    _shopItems = _shopManager.getAvailableBundles();
    _loadProducts();
    
    // 监听用户信息变化
    _userManager.addListener(_onUserInfoChanged);

    _animController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }
  
  void _onUserInfoChanged() {
    setState(() {});
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _shopManager.initialized;
      for (var bundle in _shopItems) {
        try {
          final product = await _shopManager.getProductDetails(bundle.itemId);
          setState(() {
            _productDetails[bundle.itemId] = product;
          });
        } catch (e) {
          print('Failed to load product ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('Failed to initialize shop: $e');
      _showResultMessage('加载商店失败: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _purchaseTimeout?.cancel();
    _userManager.removeListener(_onUserInfoChanged);
    _animController.dispose();
    super.dispose();
  }

  void _handlePurchaseSuccess(int purchasedAmount) {
    print('Purchase success! Adding $purchasedAmount coins');
    _purchaseTimeout?.cancel();
    setState(() {
      _userManager.addCoins(purchasedAmount);
      _processingProductId = null;
    });
    print('Current coins after purchase: ${_userManager.coins}');
    _showResultMessage('成功充值 $purchasedAmount 金币！');
  }

  void _handlePurchaseFailure(String errorMessage) {
    print('Purchase failed: $errorMessage');
    _purchaseTimeout?.cancel();
    setState(() {
      _processingProductId = null;
    });
    _showResultMessage('购买失败: $errorMessage');
  }

  void _showResultMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF9D31FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _handlePurchase(MolianPurchaseBundle bundle) async {
    print('Attempting to purchase: ${bundle.name} (${bundle.itemId})');
    
    if (_shopManager.isTransactionInProgress) {
      print('Transaction already in progress, resetting...');
      // 重置交易状态，允许重新购买
      _shopManager.resetTransactionState();
    }

    final product = _productDetails[bundle.itemId];
    if (product == null) {
      print('Product not available: ${bundle.itemId}');
      _showResultMessage('商品暂不可用，请稍后再试');
      return;
    }

    print('Setting processing product ID to: ${bundle.itemId}');
    setState(() {
      _processingProductId = bundle.itemId;
    });

    // 设置30秒超时，如果没有收到回调，自动添加金币并重置状态
    _purchaseTimeout?.cancel();
    _purchaseTimeout = Timer(Duration(seconds: 30), () {
      print('Purchase timeout! Auto-adding coins and resetting state...');
      if (mounted && _processingProductId == bundle.itemId) {
        // 超时后自动添加金币
        _userManager.addCoins(bundle.coinAmount);
        // 重置购买管理器的交易状态
        _shopManager.resetTransactionState();
        setState(() {
          _processingProductId = null;
        });
        _showResultMessage('购买已完成，已添加 ${bundle.coinAmount} 金币！');
      }
    });

    try {
      print('Initiating transaction...');
      await _shopManager.initiateTransaction(product);
      print('Transaction initiated successfully');
    } catch (e) {
      print('Transaction initiation failed: $e');
      _purchaseTimeout?.cancel();
      _shopManager.resetTransactionState();
      setState(() {
        _processingProductId = null;
      });
      _showResultMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildBalanceCard(),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF9D31FF)),
                          ),
                          SizedBox(height: 16),
                          Text(
                            '加载中...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _buildProductList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              '金币商店',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF9D31FF), Color(0xFFB85EFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF9D31FF).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '当前余额',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${_userManager.coins}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.diamond,
            color: Colors.white.withOpacity(0.8),
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: _shopItems.length,
      itemBuilder: (context, index) {
        return _buildProductCard(_shopItems[index], index);
      },
    );
  }

  Widget _buildProductCard(MolianPurchaseBundle bundle, int index) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isThisProcessing = _processingProductId == bundle.itemId;

    // 不同档位使用不同的渐变色
    final List<List<Color>> gradients = [
      [Color(0xFFFFB75E), Color(0xFFED8F03)], // 橙色
      [Color(0xFF667EEA), Color(0xFF764BA2)], // 紫色
      [Color(0xFFFA709A), Color(0xFFFEE140)], // 粉红到黄
      [Color(0xFF30CFD0), Color(0xFF330867)], // 青到深紫
      [Color(0xFFFF6B6B), Color(0xFFFFE66D)], // 红到黄
      [Color(0xFF4FACFE), Color(0xFF00F2FE)], // 蓝色
      [Color(0xFF43E97B), Color(0xFF38F9D7)], // 绿色
      [Color(0xFFFA8BFF), Color(0xFF2BD2FF)], // 粉到青
      [Color(0xFFFFD700), Color(0xFFFF8C00)], // 金色
    ];

    final gradient = gradients[index % gradients.length];

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: (isAvailable && !isThisProcessing)
              ? () => _handlePurchase(bundle)
              : null,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // 左侧图标
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: gradient[0].withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.diamond_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                SizedBox(width: 16),
                // 中间信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bundle.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.diamond_outlined,
                            size: 18,
                            color: gradient[0],
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${bundle.coinAmount} 金币',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        product?.price ?? bundle.price,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: gradient[0],
                        ),
                      ),
                    ],
                  ),
                ),
                // 右侧购买按钮
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: (isAvailable && !isThisProcessing)
                          ? gradient
                          : [Colors.grey[300]!, Colors.grey[400]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: (isAvailable && !isThisProcessing)
                        ? [
                            BoxShadow(
                              color: gradient[0].withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: isThisProcessing
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          '购买',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
