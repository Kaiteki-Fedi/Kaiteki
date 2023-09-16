import "package:flutter/rendering.dart";

enum Corner {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class CornerPainter extends CustomPainter {
  final Paint cornerPaint;
  final Corner corner;

  const CornerPainter(this.corner, this.cornerPaint);

  @override
  void paint(Canvas canvas, Size size) {
    final points = switch (corner) {
      Corner.topLeft => [
          Offset.zero,
          Offset(size.width, 0),
          Offset(0, size.height),
        ],
      Corner.topRight => [
          Offset.zero,
          Offset(size.width, 0),
          Offset(size.width, size.height),
        ],
      Corner.bottomLeft => [
          Offset.zero,
          Offset(0, size.height),
          Offset(size.width, 0),
        ],
      Corner.bottomRight => [
          Offset(size.width, 0),
          Offset(size.width, size.height),
          Offset(0, size.height),
        ],
    };

    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CornerPainter oldDelegate) {
    return oldDelegate.cornerPaint != cornerPaint &&
        oldDelegate.corner != corner;
  }
}
