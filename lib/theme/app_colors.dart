import 'package:flutter/material.dart';

/// 探友品牌色
class AppColors {
  static const primary = Color(0xFFC94A5A);
  static const primarySoft = Color(0xFFE07A6A);
  static const primaryPale = Color(0xFFEBA89A);
  static const pageBg = Color(0xFFF5F3F1);
  static const cardBg = Color(0xFFFAF8F6);
  static const textMain = Color(0xFF1F1A1A);
  static const textSub = Color(0xFF6B6560);

  static const brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primarySoft],
  );
}
