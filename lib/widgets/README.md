# 自定义Widget组件

## CoinIcon - 金币图标

一个自定义的金币图标Widget，模仿橙黄色渐变圆形背景上带有白色星星的设计。

### 特性

- 🎨 橙黄色径向渐变背景
- ⭐ 白色五角星图标
- 💫 可选阴影效果
- 📏 可自定义尺寸

### 使用方法

```dart
import 'package:molian/widgets/coin_icon.dart';

// 基本使用
CoinIcon()

// 自定义尺寸
CoinIcon(size: 50)

// 不显示阴影
CoinIcon(size: 40, showShadow: false)
```

### 参数

- `size` (double): 图标尺寸，默认40
- `showShadow` (bool): 是否显示阴影，默认true

### 设计说明

金币图标使用径向渐变实现立体感：
- 中心：浅黄色 (#FFF4D6)
- 中间：金黄色 (#FFD54F)
- 外围：深金色 (#FFB300)
- 边缘：橙色 (#FF8F00)

星星使用CustomPainter绘制，带有轻微的橙色阴影增强立体效果。

### 应用位置

- ✅ 金币商店 - 余额卡片
- ✅ 金币商店 - 商品卡片
- ✅ AI助手 - 金币余额显示
- ✅ 个人中心 - 金币余额卡片
