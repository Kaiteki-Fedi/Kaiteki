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

extension KaitekiEdgeInsetsDirectionalExtension on EdgeInsetsDirectional {
  // HACK(Craftplacer): https://github.com/flutter/flutter/issues/137475
  EdgeInsetsDirectional copyWith({
    double? start,
    double? top,
    double? end,
    double? bottom,
  }) {
    return EdgeInsetsDirectional.only(
      start: start ?? this.start,
      top: top ?? this.top,
      end: end ?? this.end,
      bottom: bottom ?? this.bottom,
    );
  }
}
