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
