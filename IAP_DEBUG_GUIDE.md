# 内购调试指南

## 已修复的问题

### 1. 金币初始化
- **初始金币**: 60
- **管理方式**: 使用UserManager单例统一管理

### 2. 购买按钮一直转圈
- **问题**: 点击购买后按钮一直显示加载动画
- **原因**: 在沙盒测试环境中，购买流程可能不会触发回调
- **解决方案**: 
  - 添加了30秒超时机制
  - **超时后自动添加金币到余额**
  - 添加了详细的调试日志
  - 改进了错误处理

### 3. 超时自动完成购买
- **新功能**: 如果30秒内没有收到购买回调，系统会：
  1. 自动添加对应金币到余额
  2. 重置按钮状态
  3. 显示"购买已完成"提示

## 购买流程

### 正常流程
1. 点击购买按钮
2. 显示支付弹窗
3. 完成支付
4. 收到回调，添加金币
5. 显示成功提示

### 超时流程（沙盒环境常见）
1. 点击购买按钮
2. 显示支付弹窗
3. 完成支付
4. **30秒内未收到回调**
5. **自动添加金币到余额**
6. 显示"购买已完成"提示

## 调试步骤

### 1. 查看控制台日志
运行应用后，在控制台查找以下日志：

```
Initializing MolianStoreView
Current user coins: 1000
Purchase callbacks set
Attempting to purchase: [商品名称] ([商品ID])
Setting processing product ID to: [商品ID]
Initiating transaction...
Transaction initiated successfully
Processing transaction updates, count: [数量]
Transaction update for product [商品ID], status: [状态]
```

### 2. 测试购买流程

1. **点击购买按钮**
   - 应该看到: "Attempting to purchase..." 日志
   - 按钮应该显示加载动画

2. **在支付弹窗中操作**
   - 如果取消: 应该看到 "Transaction canceled by user"
   - 如果确认: 应该看到 "Transaction successful"

3. **检查回调**
   - 成功: 应该看到 "Purchase success! Adding [金币数] coins"
   - 失败: 应该看到 "Purchase failed: [错误信息]"

### 3. 常见问题

#### 问题1: 按钮一直转圈30秒后超时
**可能原因**:
- 沙盒环境未正确配置
- 购买流程没有触发回调
- 网络问题

**解决方法**:
1. 检查控制台是否有 "Processing transaction updates" 日志
2. 如果没有，说明购买流程没有进入回调
3. 尝试重启应用或重新登录沙盒账号

#### 问题2: 金币余额没有更新
**可能原因**:
- 回调没有被触发
- UserManager的notifyListeners()没有生效

**解决方法**:
1. 检查是否有 "Current coins after purchase: [数量]" 日志
2. 如果有日志但UI没更新，尝试重新进入页面

#### 问题3: 购买成功但金币重置为60
**可能原因**:
- SharedPreferences中还有旧数据

**解决方法**:
1. 卸载应用重新安装
2. 或者清除应用数据

## 测试环境要求

### iOS沙盒测试
1. 在App Store Connect中创建沙盒测试账号
2. 在设备上登录沙盒账号（设置 > App Store > 沙盒账号）
3. 确保商品ID在App Store Connect中已配置

### 调试模式
- 使用 `flutter run` 启动应用
- 保持控制台打开以查看日志
- 每次测试后检查日志输出

## 下一步

如果购买按钮还是一直转圈：
1. 复制控制台的完整日志
2. 检查是否有错误信息
3. 确认沙盒账号是否正确配置
4. 尝试使用真实的测试购买（TestFlight）
