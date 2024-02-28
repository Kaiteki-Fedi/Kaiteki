import 'package:flutter/material.dart';

extension DeflateExtensions on Rect {
  Rect deflateWithEdgeInsets(EdgeInsets margin) {
    return Rect.fromLTRB(
      left + margin.left,
      top + margin.top,
      right - margin.right,
      bottom - margin.bottom,
    );
  }
}

extension ColorTextStyleExtension on Color {
  TextStyle get textStyle => TextStyle(color: this);
}

extension WidgetListExtension on List<Widget> {
  List<Widget> spacedHorizontally(double gap) {
    return [
      for (var i = 0; i< length; i++) ...[
        if (i != 0) SizedBox(width: gap),
        this[i],
      ],

        ];
  }

  List<Widget> spacedVertically(double gap) {
    return [
      for (var i = 0; i< length; i++) ...[
        if (i != 0) SizedBox(height: gap),
        this[i],
      ],

    ];
  }
}
