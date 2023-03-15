import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/shared/social_icon_animation.dart";

class CountButton extends ConsumerWidget {
  final bool enabled;
  final bool active;
  final bool? animate;

  final int? count;
  final Color? activeColor;
  final Color? color;

  final Widget icon;
  final Widget? activeIcon;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final FocusNode? focusNode;
  final bool showNumber;
  final bool expanded;

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
    this.showNumber = true,
    this.expanded = true,
    this.animate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callback = enabled ? onTap : null;
    final color = _getColor(context);
    final count = this.count;

    final hasNumber = count != null && count >= 1;
    final shortenedCount = NumberFormat.compact() //
        .format(count ?? 0)
        .toLowerCase();

    final showCount =
        showNumber && hasNumber && !ref.watch(hidePostMetrics).value;

    final icon = _buildIcon(color);

    return RawMaterialButton(
      onPressed: callback,
      onLongPress: onLongPress,
      enableFeedback: enabled,
      focusNode: focusNode,
      constraints: BoxConstraints(
        minWidth: (expanded && showCount) ? 88.0 : 0.0,
        minHeight: 36.0,
      ),
      shape: const StadiumBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: !expanded
            ? icon
            : Row(
                children: [
                  icon,
                  if (showCount) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: DefaultTextStyle.merge(
                        style: Theme.of(context)
                            .ktkTextTheme!
                            .countTextStyle
                            .copyWith(color: color),
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

  Widget _buildIcon(Color color) {
    var icon = this.icon;
    final activeIcon = this.activeIcon;
    if (activeIcon != null && active) icon = activeIcon;

    if (animate ?? true) {
      icon = SocialIconAnimation(
        active: active,
        circleColors: List.filled(2, color),
        bubbleColors: List.filled(4, color),
        child: icon,
      );
    }

    return IconTheme(
      data: IconThemeData(color: color),
      child: icon,
    );
  }

  Color _getColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!enabled || onTap == null) return colorScheme.outlineVariant;

    final inactiveColor = color ?? colorScheme.outline;
    if (active) return activeColor ?? inactiveColor;

    return inactiveColor;
  }
}
