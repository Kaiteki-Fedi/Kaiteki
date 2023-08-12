import "package:flutter/rendering.dart";

enum PrideFlag {
  trans([
    Color(0xFF5BCEFA),
    Color(0xFFF5A9B8),
    Color(0xFFFFFFFF),
    Color(0xFFF5A9B8),
    Color(0xFF5BCEFA)
  ]),
  lesbian([
    Color(0xFFD62900),
    Color(0xFFFF9B55),
    Color(0xFFFFFFFF),
    Color(0xFFD462A6),
    Color(0xFFA50062)
  ]),
  pan([Color(0xFFFF1B8D), Color(0xFFFFD900), Color(0xFF1BB3FF)]),
  bi([
    Color(0xFFD70071),
    Color(0xFFD70071),
    Color(0xFF9C4E97),
    Color(0xFF0035AA),
    Color(0xFF0035AA)
  ]),
  nonBinary([
    Color(0xFFFFF42F),
    Color(0xFFFFFFFF),
    Color(0xFF9C59D1),
    Color(0xFF292929)
  ]),
  mlm([
    Color(0xFF078D70),
    Color(0xFF98E8C1),
    Color(0xFFFFFFFF),
    Color(0xFF7BADE2),
    Color(0xFF3D1A78),
  ]),
  pride([
    Color(0xFFE60000),
    Color(0xFFFF8E00),
    Color(0xFFFFEF00),
    Color(0xFF00821B),
    Color(0xFF004BFF),
    Color(0xFF780089)
  ]);

  final List<Color> colors;

  const PrideFlag(this.colors);
}

class PridePainter extends CustomPainter {
  final PrideFlag flag;

  const PridePainter(this.flag);

  @override
  void paint(Canvas canvas, Size size) {
    final stripes = flag.colors;
    final height = size.height / stripes.length;
    for (var i = 0; i < stripes.length; i++) {
      final y = height * i;
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          y,
          size.width,
          size.height - y,
        ),
        Paint()..color = stripes[i],
      );
    }
  }

  @override
  bool shouldRepaint(PridePainter oldDelegate) => flag == oldDelegate.flag;
}
