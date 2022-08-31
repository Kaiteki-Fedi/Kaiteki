import 'package:flutter/material.dart';

class RoundedUnderlineTabIndicator extends Decoration {
  const RoundedUnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.radius = Radius.zero,
    this.insets = EdgeInsets.zero,
  });

  final BorderSide borderSide;

  final Radius radius;

  final EdgeInsetsGeometry insets;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is RoundedUnderlineTabIndicator) {
      return RoundedUnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
        radius: Radius.lerp(a.radius, radius, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is RoundedUnderlineTabIndicator) {
      return RoundedUnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
        radius: Radius.lerp(radius, b.radius, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RoundedUnderlinePainter(this, onChanged);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final indicator = insets.resolve(textDirection).deflateRect(rect);
    return Rect.fromLTWH(
      indicator.left,
      indicator.bottom - borderSide.width,
      indicator.width,
      borderSide.width,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _RoundedUnderlinePainter extends BoxPainter {
  _RoundedUnderlinePainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  final RoundedUnderlineTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final rect = offset & configuration.size!;
    final textDirection = configuration.textDirection!;
    final indicator = decoration
        ._indicatorRectFor(rect, textDirection)
        .deflate(decoration.borderSide.width / 2.0);
    final paint = decoration.borderSide.toPaint()..strokeCap = StrokeCap.square;

    canvas
      ..drawLine(indicator.bottomLeft, indicator.bottomRight, paint)
      ..drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTRB(
            rect.left,
            rect.bottom - decoration.borderSide.width,
            rect.right,
            rect.bottom,
          ),
          topLeft: decoration.radius,
          topRight: decoration.radius,
        ),
        paint,
      );
  }
}
