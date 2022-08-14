import 'package:flutter/material.dart';

class ToggleIconButton extends StatelessWidget {
  final Widget icon;
  final Widget? selectedIcon;
  final VoidCallback? onPressed;
  final bool selected;
  final String? tooltip;

  const ToggleIconButton({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.onPressed,
    required this.selected,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: selected ? Theme.of(context).colorScheme.primary : null,
      icon: _getIcon(),
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }

  Widget _getIcon() {
    if (selected) return selectedIcon ?? icon;
    return icon;
  }
}
