/// Implements code for helping with Material's responsive layout guidelines.
class LayoutHelper {
  /// Returns a [ScreenSize] as defined by <https://material.io/design/layout/responsive-layout-grid.html#breakpoints>
  static ScreenSize getScreenSize(num width) {
    if (width >= 1440) {
      return ScreenSize.l;
    } else if (width >= 1240) {
      return ScreenSize.m;
    } else if (width >= 600) {
      return ScreenSize.s;
    } else {
      return ScreenSize.xs;
    }
  }
}

extension ScreenSizeExtensions on ScreenSize {
  int toInt() {
    switch (this) {
      case ScreenSize.xs:
        return 0;
      case ScreenSize.s:
        return 1;
      case ScreenSize.m:
        return 2;
      case ScreenSize.l:
        return 3;
    }
  }
}

enum ScreenSize {
  /// Extra-small (phone)
  xs,

  /// Small (tablet)
  s,

  /// Medium (laptop)
  m,

  /// Large (desktop)
  l,
}
