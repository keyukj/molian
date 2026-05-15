# IPA上传问题修复说明

## 问题描述

错误信息：
```
1 package(s) were not uploaded because they had problems:
/Users/runner/work/molian/molian/build/ios/ipa/探友.ipa - Error Messages:
Could not upload file: 探友.ipa
```

## 问题原因

IPA文件名包含中文字符"探友"，导致上传到App Store Connect失败。苹果的上传工具（Transporter/altool）对文件名有严格要求：
- ❌ 不支持中文字符
- ❌ 不支持特殊字符
- ✅ 只支持ASCII字符（英文字母、数字、下划线、连字符）

## 解决方案

### 已修复的配置

修改了 `ios/Runner/Info.plist` 文件：

**修改前：**
```xml
<key>CFBundleName</key>
<string>探友</string>
```

**修改后：**
```xml
<key>CFBundleName</key>
<string>Molian</string>
```

### 说明

- `CFBundleName`: 用于生成IPA文件名（必须是英文）
- `CFBundleDisplayName`: 用于显示在用户设备上的应用名称（可以是中文"探友"）

这样修改后：
- ✅ IPA文件名：`Molian.ipa` （可以正常上传）
- ✅ 用户看到的应用名：`探友` （保持中文显示）

## 重新构建步骤

### 1. 清理旧的构建文件
```bash
flutter clean
```

### 2. 重新构建IPA
```bash
flutter build ipa --release
```

或者如果使用CI/CD：
```bash
flutter build ios --release --no-codesign
# 然后使用xcodebuild archive和export
```

### 3. 验证IPA文件名
构建完成后，检查文件名：
```bash
ls -la build/ios/ipa/
```

应该看到：`Molian.ipa` 而不是 `探友.ipa`

### 4. 上传到App Store Connect

**方法1：使用Transporter（推荐）**
1. 打开Transporter应用
2. 拖入 `Molian.ipa` 文件
3. 点击"交付"

**方法2：使用命令行**
```bash
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/Molian.ipa \
  --username "your-apple-id@email.com" \
  --password "app-specific-password"
```

**方法3：使用fastlane**
```bash
fastlane deliver --ipa build/ios/ipa/Molian.ipa
```

## 其他注意事项

### 1. 应用显示名称
如果需要修改用户看到的应用名称，编辑 `CFBundleDisplayName`：
```xml
<key>CFBundleDisplayName</key>
<string>探友</string>  <!-- 这个可以保持中文 -->
```

### 2. CI/CD配置
如果使用GitHub Actions或其他CI/CD，确保构建脚本使用正确的配置：
```yaml
- name: Build IPA
  run: flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
```

### 3. 版本号
当前版本：`1.0.2+7`
- 版本名：1.0.2
- 构建号：7

每次提交新版本时，需要增加构建号。

## 验证清单

上传前请确认：
- ✅ IPA文件名是英文（Molian.ipa）
- ✅ Bundle ID正确
- ✅ 版本号和构建号正确
- ✅ 签名和配置文件有效
- ✅ 所有必需的权限描述已添加
- ✅ 应用图标和启动屏幕正确

## 常见问题

### Q: 修改后用户看到的应用名会变吗？
A: 不会。用户看到的是 `CFBundleDisplayName`（探友），不是 `CFBundleName`。

### Q: 需要重新提交审核吗？
A: 如果只是修改了Bundle Name，不需要重新审核。但如果已经在审核中，建议等审核完成后再更新。

### Q: 其他语言的应用名怎么办？
A: 可以使用InfoPlist.strings文件支持多语言：
```
// zh-Hans.lproj/InfoPlist.strings
"CFBundleDisplayName" = "探友";

// en.lproj/InfoPlist.strings  
"CFBundleDisplayName" = "Molian";
```

## 相关文档

- [Apple - Info.plist Keys](https://developer.apple.com/documentation/bundleresources/information_property_list)
- [Flutter - Build and release an iOS app](https://docs.flutter.dev/deployment/ios)
- [App Store Connect - Upload your app](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds)
