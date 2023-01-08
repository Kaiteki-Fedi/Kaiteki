import 'dart:ui';

import 'package:flutter/material.dart';

class UnblurOnHover extends StatefulWidget {
  final Widget child;

  const UnblurOnHover({super.key, required this.child});

  @override
  State<UnblurOnHover> createState() => _UnblurOnHoverState();
}

class _UnblurOnHoverState extends State<UnblurOnHover> {
  bool blurred = true;

  @override
  Widget build(BuildContext context) {
    final imageFilter = ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0);
    return MouseRegion(
      onEnter: (_) => setState(() => blurred = false),
      onExit: (_) => setState(() => blurred = true),
      child: blurred
          ? ImageFiltered(imageFilter: imageFilter, child: widget.child)
          : widget.child,
    );
  }
}
