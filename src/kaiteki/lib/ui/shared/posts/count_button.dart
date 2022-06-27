import 'package:flutter/material.dart';

class CountButton extends StatelessWidget {
  final bool active;
  final bool disabled;

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
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final callback = active ? () {} : (disabled ? null : onTap);
    final color = _getColor(context);
    final currentIcon = active ? (activeIcon ?? icon) : icon;
    final count = this.count;
    final hasNumber = count == null || count >= 1;

    return Row(
      children: [
        IconButton(
          icon: currentIcon,
          color: color,
          onPressed: callback,
          enableFeedback: !disabled,
          focusNode: focusNode,
          splashRadius: 18,
        ),
        if (hasNumber) Text(count.toString()),
      ],
    );

    // if (hasNumber) {
    //   return IconButton(
    //     icon: currentIcon,
    //     color: iconColor,
    //     onPressed: callback,
    //     enableFeedback: !disabled,
    //     focusNode: focusNode,
    //     splashRadius: 18,
    //   );
    // } else {
    //   return TextButton.icon(
    //     icon: currentIcon,
    //     onPressed: callback,
    //     style: ButtonStyle(
    //       foregroundColor: MaterialStateProperty.all<Color>(iconColor),
    //     ),
    //     label: Text(count.toString()),
    //     focusNode: focusNode,
    //   );
    // }
  }

  Color _getColor(BuildContext context) {
    final inactiveColor = color ?? Theme.of(context).colorScheme.onBackground;
    if (active) return activeColor ?? inactiveColor;
    return inactiveColor;
  }
}
