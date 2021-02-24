import 'package:flutter/material.dart';

class CountButton extends StatelessWidget {
  final bool active;
  final bool disabled;

  final int count;
  final Color activeColor;
  final Color color;

  final Widget icon;
  final Widget activeIcon;

  final VoidCallback onTap;
  const CountButton({Key key, this.active = false, this.count = 0, this.color, this.activeColor, this.icon, this.activeIcon, this.onTap, this.disabled = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var inactiveColor = color;

    if (inactiveColor == null) {
      inactiveColor = Theme.of(context).disabledColor;
    }

    var callback = active ? () {} : (disabled ? null : onTap);
    var iconColor = active ? (activeColor ?? inactiveColor) : inactiveColor;
    var currentIcon = active ? (activeIcon ?? icon): icon;

    if (count == null || count < 1) {
      return IconButton(
        icon: currentIcon,
        color: iconColor,
        onPressed: callback,
        enableFeedback: !disabled,
      );
    } else {
      return TextButton.icon(
        icon: currentIcon,
        onPressed: callback,
        label: Text(count.toString()),
      );
    }
  }
}