import "package:flutter/material.dart";

enum AppBadgeKind {
  alpha("Alpha", Color(0xFFfa4f62), Colors.white),
  beta("Beta", Color(0xFFfd9044), Colors.black),
  debug("Debug", Color(0xFFB71C1C), Colors.white);

  final Color foregroundColor;
  final Color backgroundColor;
  final String text;

  const AppBadgeKind(this.text, this.backgroundColor, this.foregroundColor);
}
