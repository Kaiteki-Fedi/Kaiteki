import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/utils/extensions.dart';

class BreakpointContainer extends StatelessWidget {
  final Breakpoint breakpoint;
  final bool center;
  final Widget child;

  const BreakpointContainer({
    super.key,
    required this.breakpoint,
    required this.child,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    final width = breakpoint.body ?? double.infinity;
    final margin = breakpoint.margin ?? 0.0;
    Widget child = SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: margin),
        child: this.child,
      ),
    );

    if (center) child = Align(alignment: Alignment.topCenter, child: child);

    return child;
  }
}
