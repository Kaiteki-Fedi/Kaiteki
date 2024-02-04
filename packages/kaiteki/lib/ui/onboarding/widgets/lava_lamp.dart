import "dart:math";

import "package:flutter/material.dart";

/// Just a cool lava lamp. For decoration purposes only.
class LavaLamp extends StatefulWidget {
  final Color color1;
  final Color color2;

  const LavaLamp({
    super.key,
    required this.color1,
    required this.color2,
  });

  @override
  State<LavaLamp> createState() => _LavaLampState();
}

class _LavaLampState extends State<LavaLamp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          willChange: true,
          painter: _LavaLampPainter(
            animationValue: _controller.value,
            colors: [widget.color1, widget.color2],
          ),
        );
      },
    );
  }
}

class _LavaLampPainter extends CustomPainter {
  final List<Color> colors;
  final double animationValue;

  const _LavaLampPainter({
    required this.colors,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final animatedPie = animationValue * pi;
    final gradient = RadialGradient(
      center: Alignment(
        sin(animatedPie * 4),
        cos(animatedPie * 2),
      ),
      radius: 4 + sin(animatedPie * 6),
      colors: colors,
      stops: const <double>[0.0, 1.0],
    );
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _LavaLampPainter oldDelegate) {
    return colors != oldDelegate.colors ||
        animationValue != oldDelegate.animationValue;
  }
}
