class MolianPurchaseBundle {
  final String itemId;
  final String name;
  final String type;
  final int coinAmount;
  final String price;
  final String description;
  final String locale;
  final String category;

  const MolianPurchaseBundle({
    required this.itemId,
    required this.name,
    required this.type,
    required this.coinAmount,
    required this.price,
    required this.description,
    required this.locale,
    required this.category,
  });
}

const List<MolianPurchaseBundle> shopInventory = <MolianPurchaseBundle>[
  MolianPurchaseBundle(
    itemId: 'molian8',
    name: '入门礼包',
    type: 'basic',
    coinAmount: 64,
    price: '¥8',
    description: '64金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
  MolianPurchaseBundle(
    itemId: 'molian18',
    name: '进阶礼包',
    type: 'basic',
    coinAmount: 141,
    price: '¥18',
    description: '141金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
  MolianPurchaseBundle(
    itemId: 'molian38',
    name: '精英礼包',
    type: 'basic',
    coinAmount: 302,
    price: '¥38',
    description: '302金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
  MolianPurchaseBundle(
    itemId: 'molian68',
    name: '豪华礼包',
    type: 'basic',
    coinAmount: 538,
    price: '¥68',
    description: '538金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
  MolianPurchaseBundle(
    itemId: 'molian98',
    name: '至尊礼包',
    type: 'basic',
    coinAmount: 768,
    price: '¥98',
    description: '768金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
  MolianPurchaseBundle(
    itemId: 'molian168',
    name: '王者礼包',
    type: 'basic',
    coinAmount: 1348,
    price: '¥169',
    description: '1348金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
  MolianPurchaseBundle(
    itemId: 'molian268',
    name: '传奇礼包',
    type: 'basic',
    coinAmount: 2168,
    price: '¥268',
    description: '2168金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
  MolianPurchaseBundle(
    itemId: 'molian398',
    name: '荣耀礼包',
    type: 'basic',
    coinAmount: 3188,
    price: '¥398',
    description: '3188金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
  MolianPurchaseBundle(
    itemId: 'molian888',
    name: '巅峰礼包',
    type: 'basic',
    coinAmount: 7188,
    price: '¥888',
    description: '7188金币',
    locale: 'zh_CN',
    category: 'basic',
  ),
];
