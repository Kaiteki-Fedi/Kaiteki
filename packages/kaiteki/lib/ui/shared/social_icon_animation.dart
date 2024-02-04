// MIT License
//
// Copyright (c) 2019 zmtzawqlp
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

import "dart:math";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:vector_math/vector_math.dart";

class SocialIconAnimation extends StatefulWidget {
  final Widget child;
  final bool active;
  final List<Color> bubbleColors;
  final List<Color> circleColors;

  const SocialIconAnimation({
    super.key,
    required this.child,
    this.active = false,
    required this.bubbleColors,
    required this.circleColors,
  });

  @override
  State<SocialIconAnimation> createState() => _SocialIconAnimationState();
}

class _SocialIconAnimationState extends State<SocialIconAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _outerCircleAnimation;
  late Animation<double> _bubblesAnimation;
  late Animation<double> _innerCircleAnimation;

  Duration get _duration => const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _controller = AnimationController(duration: _duration, vsync: this);

    _outerCircleAnimation = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.ease),
      ),
    );

    _innerCircleAnimation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.ease),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.7, curve: OvershootCurve()),
      ),
    );

    _bubblesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 1.0, curve: Curves.decelerate),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.duration != _duration) _initAnimations();
  }

  @override
  void didUpdateWidget(SocialIconAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active == oldWidget.active) return;
    if (!mounted) return;
    setState(() {
      _controller.reset();
      if (widget.active) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = IconTheme.of(context).size ?? 24.0;
    final bubbleSize = size * 2.0;
    // final circleSize = size * 0.8;
    return AnimatedBuilder(
      animation: _controller,
      child: SizedBox.square(dimension: size, child: widget.child),
      builder: (context, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              top: (size - bubbleSize) / 2.0,
              left: (size - bubbleSize) / 2.0,
              child: CustomPaint(
                size: Size.square(bubbleSize),
                painter: BubblesPainter(
                  currentProgress: _bubblesAnimation.value,
                  colors: widget.bubbleColors,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: CustomPaint(
                size: Size.square(size),
                painter: CirclePainter(
                  innerCircleRadiusProgress: _innerCircleAnimation.value,
                  outerCircleRadiusProgress: _outerCircleAnimation.value,
                  colors: widget.circleColors,
                ),
              ),
            ),
            Center(
              child: Transform.scale(
                scale: (widget.active && _controller.isAnimating)
                    ? _scaleAnimation.value
                    : 1.0,
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}

class OvershootCurve extends Curve {
  const OvershootCurve([this.period = 2.5]);

  final double period;

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    t -= 1.0;
    return t * t * ((period + 1) * t + period) + 1.0;
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter({
    required this.outerCircleRadiusProgress,
    required this.innerCircleRadiusProgress,
    required this.colors,
  }) : assert(colors.length == 2) {
    _paint.style = PaintingStyle.stroke;
  }

  final Paint _paint = Paint();

  final double outerCircleRadiusProgress;
  final double innerCircleRadiusProgress;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.width * 0.5;
    _updateCircleColor();
    final strokeWidth = outerCircleRadiusProgress * center -
        (innerCircleRadiusProgress * center);
    if (strokeWidth > 0.0) {
      _paint.strokeWidth = strokeWidth;
      canvas.drawCircle(
        Offset(center, center),
        outerCircleRadiusProgress * center,
        _paint,
      );
    }
  }

  void _updateCircleColor() {
    var colorProgress = outerCircleRadiusProgress.clamp(0.5, 1.0);
    colorProgress = _f(colorProgress, 0.5, 1.0, 0.0, 1.0);
    _paint.color = Color.lerp(colors.first, colors.last, colorProgress)!;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) {
      return true;
    }

    return oldDelegate is CirclePainter &&
        (oldDelegate.outerCircleRadiusProgress != outerCircleRadiusProgress ||
            oldDelegate.innerCircleRadiusProgress !=
                innerCircleRadiusProgress ||
            oldDelegate.colors.first != colors.first ||
            oldDelegate.colors.last != colors.last);
  }
}

double _f(
  double value,
  double fromLow,
  double fromHigh,
  double toLow,
  double toHigh,
) {
  return toLow + ((value - fromLow) / (fromHigh - fromLow) * (toHigh - toLow));
}

class BubblesPainter extends CustomPainter {
  BubblesPainter({
    required this.currentProgress,
    this.bubblesCount = 7,
    required this.colors,
  }) {
    _outerBubblesPositionAngle = 360.0 / bubblesCount;
    _circlePaints = List.filled(
      colors.length,
      Paint()..style = PaintingStyle.fill,
    );
  }

  final double currentProgress;
  final int bubblesCount;
  final List<Color> colors;

  double _outerBubblesPositionAngle = 51.42;
  Offset _center = Offset.zero;
  late List<Paint> _circlePaints;

  double _maxOuterDotsRadius = 0.0;
  double _maxInnerDotsRadius = 0.0;
  double? _maxDotSize;

  double _currentRadius1 = 0.0;
  double? _currentDotSize1 = 0.0;
  double? _currentDotSize2 = 0.0;
  double _currentRadius2 = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    _center = Offset(size.width / 2, size.height / 2);
    _maxDotSize = size.width * 0.05;
    _maxOuterDotsRadius = size.width * 0.5 - _maxDotSize! * 2;
    _maxInnerDotsRadius = 0.8 * _maxOuterDotsRadius;

    _updateOuterBubblesPosition();
    _updateInnerBubblesPosition();
    _updateBubblesPaints();
    _drawOuterBubblesFrame(canvas);
    _drawInnerBubblesFrame(canvas);
  }

  void _drawOuterBubblesFrame(Canvas canvas) {
    _drawBubblesFrame(
      canvas,
      _outerBubblesPositionAngle / 4.0 * 3.0,
      _currentRadius1,
      _currentDotSize1!,
    );
  }

  Offset _getOffset(
    Offset center,
    double radius,
    double start,
    double angle,
    int i,
  ) {
    return Offset(
      center.dx + radius * cos(radians(start + angle * i)),
      center.dy + radius * sin(radians(start + angle * i)),
    );
  }

  void _drawInnerBubblesFrame(Canvas canvas) {
    _drawBubblesFrame(
      canvas,
      _outerBubblesPositionAngle / 4.0 * 3.0 - _outerBubblesPositionAngle / 2.0,
      _currentRadius2,
      _currentDotSize2!,
    );
  }

  void _drawBubblesFrame(
    Canvas canvas,
    double start,
    double radius,
    double dotSize,
  ) {
    for (var i = 0; i < bubblesCount; i++) {
      canvas.drawCircle(
        _getOffset(
          _center,
          radius,
          start,
          _outerBubblesPositionAngle,
          i,
        ),
        dotSize,
        _circlePaints[(i + 1) % _circlePaints.length],
      );
    }
  }

  void _updateOuterBubblesPosition() {
    if (currentProgress < 0.3) {
      _currentRadius1 = _f(
        currentProgress,
        0.0,
        0.3,
        0.0,
        _maxOuterDotsRadius * 0.8,
      );
    } else {
      _currentRadius1 = _f(
        currentProgress,
        0.3,
        1.0,
        0.8 * _maxOuterDotsRadius,
        _maxOuterDotsRadius,
      );
    }
    if (currentProgress == 0) {
      _currentDotSize1 = 0;
    } else if (currentProgress < 0.7) {
      _currentDotSize1 = _maxDotSize;
    } else {
      _currentDotSize1 = _f(
        currentProgress,
        0.7,
        1.0,
        _maxDotSize!,
        0.0,
      );
    }
  }

  void _updateInnerBubblesPosition() {
    if (currentProgress < 0.3) {
      _currentRadius2 = _f(
        currentProgress,
        0.0,
        0.3,
        0.0,
        _maxInnerDotsRadius,
      );
    } else {
      _currentRadius2 = _maxInnerDotsRadius;
    }
    if (currentProgress == 0) {
      _currentDotSize2 = 0;
    } else if (currentProgress < 0.2) {
      _currentDotSize2 = _maxDotSize;
    } else if (currentProgress < 0.5) {
      _currentDotSize2 = _f(
        currentProgress,
        0.2,
        0.5,
        _maxDotSize!,
        0.3 * _maxDotSize!,
      );
    } else {
      _currentDotSize2 = _f(
        currentProgress,
        0.5,
        1.0,
        _maxDotSize! * 0.3,
        0.0,
      );
    }
  }

  void _updateBubblesPaints() {
    final progress = currentProgress.clamp(0.6, 1.0);
    final alpha = _f(progress, 0.6, 1.0, 255.0, 0.0).toInt();
    final colorProgress = _f(currentProgress, 0.0, 0.5, 0.0, 1.0);

    for (var i = currentProgress < 0.5 ? 0 : 1; i < colors.length; i++) {
      final a = colors[i];
      final b = colors[(i + 1) % colors.length];
      _circlePaints[i].color =
          Color.lerp(a, b, colorProgress)!.withAlpha(alpha);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) {
      return true;
    }

    return oldDelegate is BubblesPainter &&
        (oldDelegate.bubblesCount != bubblesCount ||
            oldDelegate.currentProgress != currentProgress ||
            listEquals(oldDelegate.colors, colors));
  }
}
