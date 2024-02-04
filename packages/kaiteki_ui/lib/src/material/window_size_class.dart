// Inspired by Jetpack Compose's WindowSizeClass.
// https://developer.android.com/guide/topics/large-screens/support-different-screen-sizes#window_size_classes

import "package:flutter/widgets.dart" show BuildContext, MediaQuery;

final class WindowSizeClass {
  final WindowHeightSizeClass height;
  final WindowWidthSizeClass width;

  const WindowSizeClass(this.width, this.height);

  factory WindowSizeClass.fromSize(num width, num height) {
    return WindowSizeClass(
      WindowWidthSizeClass.fromSize(width),
      WindowHeightSizeClass.fromSize(height),
    );
  }

  factory WindowSizeClass.fromContext(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return WindowSizeClass.fromSize(size.width, size.height);
  }
}

enum WindowHeightSizeClass {
  compact,
  medium,
  expanded;

  factory WindowHeightSizeClass.fromSize(num height) {
    return switch (height) {
      >= 900 => WindowHeightSizeClass.expanded,
      >= 480 => WindowHeightSizeClass.medium,
      _ => WindowHeightSizeClass.compact,
    };
  }

  factory WindowHeightSizeClass.fromContext(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return WindowHeightSizeClass.fromSize(height);
  }

  bool operator <(WindowHeightSizeClass other) => index < other.index;

  bool operator >(WindowHeightSizeClass other) => index > other.index;

  bool operator <=(WindowHeightSizeClass other) => index <= other.index;

  bool operator >=(WindowHeightSizeClass other) => index >= other.index;
}

enum WindowWidthSizeClass {
  compact,
  medium,
  expanded;

  factory WindowWidthSizeClass.fromSize(num width) {
    return switch (width) {
      >= 840 => WindowWidthSizeClass.expanded,
      >= 600 => WindowWidthSizeClass.medium,
      _ => WindowWidthSizeClass.compact,
    };
  }

  factory WindowWidthSizeClass.fromContext(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return WindowWidthSizeClass.fromSize(width);
  }

  bool operator <(WindowWidthSizeClass other) => index < other.index;

  bool operator >(WindowWidthSizeClass other) => index > other.index;

  bool operator <=(WindowWidthSizeClass other) => index <= other.index;

  bool operator >=(WindowWidthSizeClass other) => index >= other.index;
}
