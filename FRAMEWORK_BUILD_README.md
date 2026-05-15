# Flutter iOS Framework 打包说明

## ✅ 已完成

Flutter iOS 项目已成功打包成 framework，可以嵌入到其他 iOS 应用中。

### 打包信息
- **日期**: 2026年5月13日
- **签名证书**: Apple Distribution: guanghui fan (Z3FKF6BF5P)
- **构建类型**: Release
- **总大小**: 227MB
- **输出路径**: `/Users/admin/Desktop/molian/build/frameworks/Release/`

### 包含的 Frameworks

1. ✅ **App.xcframework** - 主应用框架（已签名）
2. ✅ **Flutter.xcframework** - Flutter引擎（已签名）
3. ✅ **app_tracking_transparency.xcframework** - ATT权限（已签名）
4. ✅ **image_picker_ios.xcframework** - 图片选择器（已签名）
5. ✅ **in_app_purchase_storekit.xcframework** - 内购功能（已签名）
6. ✅ **shared_preferences_foundation.xcframework** - 本地存储（已签名）
7. ✅ **url_launcher_ios.xcframework** - URL启动器（已签名）

### 额外文件

- `GeneratedPluginRegistrant.h` - 插件注册头文件
- `GeneratedPluginRegistrant.m` - 插件注册实现文件
- `INTEGRATION_GUIDE.md` - 详细的集成指南

## 📦 如何使用

### 方式一：使用已打包的 Frameworks

所有 frameworks 位于：
```
/Users/admin/Desktop/molian/build/frameworks/Release/
```

直接将这些文件集成到你的 iOS 项目中。详细步骤请查看 `INTEGRATION_GUIDE.md`。

### 方式二：重新构建和签名

如果需要重新构建，使用提供的自动化脚本：

```bash
cd /Users/admin/Desktop/molian
./build_and_sign_framework.sh
```

该脚本会自动完成：
1. 清理旧构建
2. 构建 iOS frameworks
3. 使用指定证书签名
4. 验证签名

### 方式三：手动构建

```bash
# 1. 清理
flutter clean

# 2. 构建
flutter build ios-framework --no-debug --no-profile --release --output=./build/frameworks

# 3. 签名（使用提供的脚本）
./sign_frameworks.sh
```

## 🔐 签名验证

所有 frameworks 已使用以下证书签名：
```
Apple Distribution: guanghui fan (Z3FKF6BF5P)
```

验证签名：
```bash
codesign --verify --deep --strict --verbose=2 ./build/frameworks/Release/App.xcframework
```

## 📱 支持的架构

- ✅ arm64 (iPhone/iPad 真机)
- ✅ x86_64 (模拟器)

## 🛠 工具脚本

项目包含以下脚本：

1. **build_and_sign_framework.sh** - 一键构建和签名
2. **sign_frameworks.sh** - 仅签名已有的 frameworks

## 📖 集成文档

详细的集成步骤和代码示例，请查看：
```
/Users/admin/Desktop/molian/build/frameworks/INTEGRATION_GUIDE.md
```

## ⚠️ 重要提示

1. **证书要求**: 集成应用需要使用相同的开发者账号或有权限使用该签名
2. **最低系统**: iOS 12.0+
3. **Bitcode**: 必须禁用 Bitcode
4. **权限配置**: 需要在主应用的 Info.plist 中添加相应权限

## 🔄 更新 Framework

如果 Flutter 代码有更新，重新运行构建脚本即可：

```bash
./build_and_sign_framework.sh
```

## 📞 问题排查

### 签名失败
- 确认证书在钥匙串中存在且有效
- 检查证书是否过期
- 确认有权限使用该证书

### 集成后运行崩溃
- 检查是否正确设置 "Embed & Sign"
- 确认已添加 GeneratedPluginRegistrant
- 检查 Info.plist 权限配置

### 模拟器无法运行
- 确认使用的是包含 x86_64 架构的 xcframework
- 检查 Xcode 构建设置

## 📂 文件结构

```
molian/
├── build/
│   └── frameworks/
│       ├── Release/
│       │   ├── App.xcframework
│       │   ├── Flutter.xcframework
│       │   ├── app_tracking_transparency.xcframework
│       │   ├── image_picker_ios.xcframework
│       │   ├── in_app_purchase_storekit.xcframework
│       │   ├── shared_preferences_foundation.xcframework
│       │   └── url_launcher_ios.xcframework
│       ├── GeneratedPluginRegistrant.h
│       ├── GeneratedPluginRegistrant.m
│       └── INTEGRATION_GUIDE.md
├── build_and_sign_framework.sh
├── sign_frameworks.sh
└── FRAMEWORK_BUILD_README.md (本文件)
```

## ✨ 下一步

1. 阅读 `INTEGRATION_GUIDE.md` 了解如何集成
2. 将 `build/frameworks/Release/` 目录中的所有文件复制到目标项目
3. 按照集成指南配置 Xcode 项目
4. 测试功能是否正常

---

**构建完成时间**: 2026-05-13
**Flutter 版本**: 3.38.7
**签名状态**: ✅ 所有 frameworks 已签名并验证
