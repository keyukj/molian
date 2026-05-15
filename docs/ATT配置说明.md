# ATT (App Tracking Transparency) 配置说明

## 概述
已为应用添加 iOS 14+ 要求的 App Tracking Transparency (ATT) 功能，在应用启动时会自动弹出权限请求对话框。

## 已完成的配置

### 1. Info.plist 配置
在 `ios/Runner/Info.plist` 中添加了必需的权限描述：

```xml
<key>NSUserTrackingUsageDescription</key>
<string>我们需要您的同意以提供个性化的内容和广告体验</string>
```

**说明**：这段文字会显示在 ATT 权限弹窗中，向用户解释为什么需要跟踪权限。你可以根据实际需求修改这段描述文字。

### 2. 依赖包
在 `pubspec.yaml` 中添加了 `app_tracking_transparency` 插件：

```yaml
app_tracking_transparency: ^2.0.4
```

### 3. 代码实现
在 `lib/main.dart` 中实现了 ATT 权限请求逻辑：

- 应用启动后自动请求 ATT 权限
- 仅在 iOS 平台执行（Android 不需要）
- 延迟 500ms 确保应用完全启动后再弹窗
- 可获取用户的授权状态和 IDFA（广告标识符）

## ATT 权限状态

用户可能的选择：
- **允许跟踪**：可以获取 IDFA，用于广告投放和分析
- **拒绝跟踪**：无法获取 IDFA，需要使用其他方式进行分析

## 测试说明

### 在模拟器/真机上测试
1. 运行应用：`flutter run`
2. 应用启动后会自动弹出 ATT 权限请求对话框
3. 选择"允许"或"拒绝"

### 重置 ATT 权限（用于重复测试）
在 iOS 设备上：
1. 打开"设置" > "隐私与安全性" > "跟踪"
2. 找到"探友"应用
3. 关闭权限开关
4. 或者在"设置" > "通用" > "传输或还原 iPhone" > "还原" > "还原位置与隐私"

## 注意事项

1. **iOS 14.5+**：ATT 是 iOS 14.5 及以上版本的强制要求
2. **App Store 审核**：如果应用使用了跟踪功能但未实现 ATT，会被拒绝上架
3. **弹窗时机**：建议在用户完成引导或登录后再弹出，当前实现是在应用启动时立即弹出
4. **描述文字**：务必如实说明跟踪用途，不要误导用户

## 自定义弹窗时机

如果想在其他时机弹出 ATT 权限请求（例如登录后），可以：

1. 从 `_MolianAppState.initState()` 中移除 `_requestATTPermission()` 调用
2. 在需要的地方调用该方法，例如：

```dart
// 在登录成功后
await _requestATTPermission();
```

## 相关资源

- [Apple ATT 官方文档](https://developer.apple.com/documentation/apptrackingtransparency)
- [app_tracking_transparency 插件文档](https://pub.dev/packages/app_tracking_transparency)
