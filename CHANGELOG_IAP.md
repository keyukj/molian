# 内购系统更新日志

## 更新内容

### 1. 更新内购商品列表
- 更新了9个内购档位,ID和金币数量如下:
  - molian8: 64金币 (¥8)
  - molian18: 141金币 (¥18)
  - molian38: 302金币 (¥38)
  - molian68: 538金币 (¥68)
  - molian98: 768金币 (¥98)
  - molian168: 1348金币 (¥169)
  - molian268: 2168金币 (¥268)
  - molian398: 3188金币 (¥398)
  - molian888: 7188金币 (¥888)

### 2. 更新初始金币
- 用户初始金币从5000改为60
- 更新了molianWaletService和molianStoreView中的初始值

### 3. 彻底重构内购UI
- 采用全新的卡片式设计
- 每个商品使用不同的渐变色彩
- 购买按钮简化为"购买"中文文字
- 价格和金币数量信息都显示在卡片内部
- 优化了小屏幕兼容性
- 添加了加载状态提示

### 4. 添加内购入口
- 在"我的"页面添加了金币余额卡片
- 点击卡片可直接进入内购页面
- 实时显示当前金币余额
- 从内购页面返回后自动刷新余额

## 文件修改列表

1. `lib/molianIAP/molianPurchaseBundle.dart` - 更新商品数据
2. `lib/molianIAP/molianWaletService.dart` - 更新初始金币
3. `lib/molianIAP/molianStoreView.dart` - 完全重构UI
4. `lib/main.dart` - 添加内购入口和金币余额显示

## 注意事项

- iOS内购流程保持不变,只更新了ID和UI
- 不进行内购ID校验,请确保在Apple后台正确配置
- 所有内购ID需要在App Store Connect中预先创建
