import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";

class CountButton extends StatelessWidget {
  final bool enabled;
  final bool active;

  final int? count;
  final Color? activeColor;
  final Color? color;

  final Widget icon;
  final Widget? activeIcon;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final FocusNode? focusNode;

  const CountButton({
    super.key,
    required this.icon,
    this.activeColor,
    this.activeIcon,
    this.color,
    this.count = 0,
    this.enabled = true,
    this.active = false,
    this.focusNode,
    this.onLongPress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final callback = enabled ? onTap : null;
    final color = _getColor(context);
    final count = this.count;

    final hasNumber = count != null && count >= 1;
    final shortenedCount = NumberFormat.compact() //
        .format(count ?? 0)
        .toLowerCase();

    return InkWell(
      onTap: callback,
      onLongPress: onLongPress,
      enableFeedback: enabled,
      focusNode: focusNode,
      customBorder: Theme.of(context).useMaterial3
          ? const StadiumBorder()
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconTheme(
              data: IconThemeData(color: color),
              child: _buildIcon(),
            ),
            if (hasNumber) ...[
              const SizedBox(width: 8),
              Expanded(
                child: DefaultTextStyle.merge(
                  style:
                      Theme.of(context).ktkTextTheme!.countTextStyle.copyWith(
                            color: color,
                          ),
                  child: Text(
                    shortenedCount,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final activeIcon = this.activeIcon;
    if (activeIcon != null && active) return activeIcon;
    return icon;
  }

  Color _getColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!enabled || onTap == null) return colorScheme.outlineVariant;

    final inactiveColor = color ?? colorScheme.onBackground;
    if (active) return activeColor ?? inactiveColor;

    return inactiveColor;
  }
}
