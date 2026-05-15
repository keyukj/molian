import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 自定义金币图标Widget
/// 橙黄色渐变圆形背景 + 白色星星
class CoinIcon extends StatelessWidget {
  final double size;
  final bool showShadow;

  const CoinIcon({
    Key? key,
    this.size = 40,
    this.showShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.3),
          radius: 1.2,
          colors: [
            Color(0xFFFFF4D6), // 浅黄色中心
            Color(0xFFFFD54F), // 金黄色
            Color(0xFFFFB300), // 深金色
            Color(0xFFFF8F00), // 橙色边缘
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: const Color(0xFFFF8F00).withValues(alpha: 0.4),
                  blurRadius: size * 0.3,
                  offset: Offset(0, size * 0.1),
                ),
              ]
            : null,
      ),
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.5, size * 0.5),
          painter: StarPainter(),
        ),
      ),
    );
  }
}

/// 绘制白色星星
class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = const Color(0xFFFFB300).withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final path = _createStarPath(size);

    // 绘制阴影
    canvas.save();
    canvas.translate(1, 2);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // 绘制星星
    canvas.drawPath(path, paint);
  }

  Path _createStarPath(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.4;
    final points = 5;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * math.pi / points) - math.pi / 2;
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
