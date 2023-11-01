import 'package:flutter/foundation.dart' show objectRuntimeType;
import 'package:flutter/painting.dart';
import 'package:kaiteki_ui/src/utils/extensions.dart';

class MarginedStadiumBorder extends StadiumBorder {
  const MarginedStadiumBorder({super.side, this.margin = EdgeInsets.zero});

  final EdgeInsets margin;

  /// Returns a copy of this MarginedStadiumBorder with the given
  /// fields replaced with the new values.
  @override
  MarginedStadiumBorder copyWith({
    BorderSide? side,
    EdgeInsets? margin,
    BorderRadiusGeometry? borderRadius,
  }) {
    return MarginedStadiumBorder(
      side: side ?? this.side,
      margin: margin ?? this.margin,
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
    return other is MarginedStadiumBorder &&
        other.side == side &&
        other.margin == margin;
  }

  @override
  int get hashCode => Object.hash(side, margin);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'MarginedStadiumBorder')}($side, $margin)';
}
