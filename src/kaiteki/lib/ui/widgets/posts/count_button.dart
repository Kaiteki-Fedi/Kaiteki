import 'package:flutter/material.dart';
import 'package:kaiteki/utils/utils.dart';

class CountButton extends StatelessWidget {
  final bool active;
  final bool disabled;
  final bool buttonOnly;

  final int? count;
  final Color? activeColor;
  final Color? color;

  final Widget icon;
  final Widget? activeIcon;

  final VoidCallback? onTap;
  final FocusNode? focusNode;

  const CountButton({
    Key? key,
    this.active = false,
    this.count = 0,
    this.color,
    this.activeColor,
    required this.icon,
    this.activeIcon,
    this.onTap,
    this.disabled = false,
    this.buttonOnly = false,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var callback = active ? () {} : (disabled ? null : onTap);
    var iconColor = _getIconColor(context);
    var currentIcon = active ? (activeIcon ?? icon) : icon;

    if (count == null || count! < 1) {
      return IconButton(
        icon: currentIcon,
        color: iconColor,
        onPressed: callback,
        enableFeedback: !disabled,
        focusNode: focusNode,
      );
    } else {
      return TextButton.icon(
        icon: currentIcon,
        onPressed: callback,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(iconColor),
        ),
        label: Text(count.toString()),
        focusNode: focusNode,
      );
    }
  }

  Color _getIconColor(BuildContext context) {
    var inactiveColor = color;
    var theme = Theme.of(context);

    inactiveColor ??= theme.disabledColor;

    if (buttonOnly) {
      return Utils.getLocalTextColor(context);
    } else if (active) {
      return activeColor ?? inactiveColor;
    } else {
      return inactiveColor;
    }
  }
}
