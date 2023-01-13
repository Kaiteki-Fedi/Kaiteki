import "package:flutter/widgets.dart";

class FloatingActionButtonData {
  final VoidCallback? onTap;
  final String tooltip;
  final String text;
  final IconData icon;

  FloatingActionButtonData({
    this.onTap,
    required this.tooltip,
    required this.text,
    required this.icon,
  });
}
