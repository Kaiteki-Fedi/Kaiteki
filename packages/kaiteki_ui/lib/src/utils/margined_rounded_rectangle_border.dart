import 'package:flutter/foundation.dart' show objectRuntimeType;
import 'package:flutter/painting.dart';
import 'package:kaiteki_ui/src/utils/extensions.dart';

class MarginedRoundedRectangleBorder extends RoundedRectangleBorder {
  const MarginedRoundedRectangleBorder({
    super.side,
    super.borderRadius,
    this.margin = EdgeInsets.zero,
  });

  final EdgeInsets margin;

  /// Returns a copy of this MarginedRoundedRectangleBorder with the given
  /// fields replaced with the new values.
  @override
  MarginedRoundedRectangleBorder copyWith({
    BorderSide? side,
    EdgeInsets? margin,
    BorderRadiusGeometry? borderRadius,
  }) {
    return MarginedRoundedRectangleBorder(
      side: side ?? this.side,
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return super.getInnerPath(
      rect.deflateWithEdgeInsets(margin),
      textDirection: textDirection,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return super.getOuterPath(
      rect.deflateWithEdgeInsets(margin),
      textDirection: textDirection,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    return super.paint(
      canvas,
      rect.deflateWithEdgeInsets(margin),
      textDirection: textDirection,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MarginedRoundedRectangleBorder &&
        other.side == side &&
        other.borderRadius == borderRadius &&
        other.margin == margin;
  }

  @override
  int get hashCode => Object.hash(side, borderRadius, margin);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'MarginedRoundedRectangleBorder')}($side, $borderRadius, $margin)';
}
