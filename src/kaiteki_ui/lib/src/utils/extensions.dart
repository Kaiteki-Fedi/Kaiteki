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

extension BadgingExtension on Widget {
  Widget wrapWithBadge(int? count) {
    if (count == null || count <= 0) return this;

    return Badge(
      label: Text(count.toString()),
      child: this,
    );
  }
}
