import 'package:flutter/widgets.dart';

const int largeBreakpoint = 1440;
const int mediumBreakpoint = 1240;
const int smallBreakpoint1 = 600;
const int smallBreakpoint2 = 905;

/// Returns a [ScreenSize] based on the provided width.
///
/// Read more: <https://material.io/design/layout/responsive-layout-grid.html#breakpoints>
ScreenSize getScreenSize(num width) {
  if (width >= largeBreakpoint) {
    return ScreenSize.l;
  } else if (width >= mediumBreakpoint) {
    return ScreenSize.m;
  } else if (width >= smallBreakpoint1) {
    return ScreenSize.s;
  } else {
    return ScreenSize.xs;
  }
}

double? getBodySize(num width) {
  if (width >= largeBreakpoint) {
    return 1040;
  } else if (width >= mediumBreakpoint) {
    return null;
  } else if (width >= smallBreakpoint2) {
    return 840;
  } else {
    return null;
  }
}

double? getMargin(num width) {
  if (width >= largeBreakpoint) {
    return null;
  } else if (width >= mediumBreakpoint) {
    return 200;
  } else if (width >= smallBreakpoint2) {
    return null;
  } else if (width >= smallBreakpoint1) {
    return 32;
  } else {
    return 16;
  }
}

EdgeInsets getMarginPadding(num width) {
  final margin = getMargin(width);

  if (margin == null) {
    return EdgeInsets.zero;
  } else {
    return EdgeInsets.symmetric(horizontal: margin);
  }
}

double getColumns(num width) {
  if (width >= smallBreakpoint2) {
    return 12;
  } else if (width >= smallBreakpoint1) {
    return 8;
  } else {
    return 4;
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

class ResponsiveLayoutBuilder extends StatelessWidget {
  final bool center;
  final Function(
    BuildContext context,
    BoxConstraints constraints,
    ResponsiveLayoutData data,
  ) builder;

  const ResponsiveLayoutBuilder({
    Key? key,
    this.center = true,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = LayoutBuilder(builder: buildOnConstraints);

    if (center) {
      widget = Center(child: widget);
    }

    return widget;
  }

  Widget buildOnConstraints(context, constraints) {
    final layout = ResponsiveLayoutData.width(constraints.maxWidth);
    final margin = layout.margin;
    final marginPadding = margin == null
        ? EdgeInsets.zero
        : EdgeInsets.symmetric(horizontal: margin);

    return SizedBox(
      width: layout.bodySize,
      child: Padding(
        padding: marginPadding,
        child: builder(context, constraints, layout),
      ),
    );
  }
}

class ResponsiveLayoutData {
  final double? margin;
  final double columns;
  final double? bodySize;

  const ResponsiveLayoutData({
    required this.bodySize,
    required this.margin,
    required this.columns,
  });

  factory ResponsiveLayoutData.width(num width) {
    return ResponsiveLayoutData(
      bodySize: getBodySize(width),
      margin: getMargin(width),
      columns: getColumns(width),
    );
  }
}
