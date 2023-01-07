import 'package:flutter/material.dart';

class DfpWidget extends StatelessWidget {
  final double? bottom;
  final double? top;
  final double? left;
  final double? right;
  final BoxConstraints constraints;
  final Widget child;

  const DfpWidget({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.child,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _getEdgeInsets(constraints.maxWidth, constraints.maxHeight),
      child: child,
    );
  }

  EdgeInsets _getEdgeInsets(double width, double height) {
    return EdgeInsets.fromLTRB(
      left == null ? 0 : width * left!,
      top == null ? 0 : height * top!,
      right == null ? 0 : width * right!,
      bottom == null ? 0 : height * bottom!,
    );
  }
}
