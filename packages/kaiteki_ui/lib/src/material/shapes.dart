import "package:flutter/rendering.dart";

import "border_radii.dart";

class Shapes {
  /// Rectangle with a radius of 0.0dp
  static const none = RoundedRectangleBorder();

  /// Rounded rectangle with a radius of 4.0dp
  static const extraSmall =
      RoundedRectangleBorder(borderRadius: BorderRadii.extraSmall);

  /// Rounded rectangle with a radius of 8.0dp
  static const small = RoundedRectangleBorder(borderRadius: BorderRadii.small);

  /// Rounded rectangle with a radius of 12.0dp
  static const medium =
      RoundedRectangleBorder(borderRadius: BorderRadii.medium);

  /// Rounded rectangle with a radius of 16.0dp
  static const large = RoundedRectangleBorder(borderRadius: BorderRadii.large);

  /// Rounded rectangle with a radius of 28.0dp
  static const extraLarge =
      RoundedRectangleBorder(borderRadius: BorderRadii.extraLarge);

  /// Stadium shape
  static const full = StadiumBorder();
}
