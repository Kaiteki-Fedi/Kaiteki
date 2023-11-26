import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/text_theme.dart";
import "package:kaiteki/ui/shared/common.dart";
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

  final String? tooltip;

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
    this.tooltip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _getColor(context);
    final count = this.count;

    final hasNumber = count != null && count >= 1;
    final shortenedCount = NumberFormat.compact() //
        .format(count ?? 0)
        .toLowerCase();

    final showCount =
        showNumber && hasNumber && !ref.watch(hidePostMetrics).value;

    final textStyle = (Theme.of(context).ktkTextTheme?.countTextStyle ??
            DefaultKaitekiTextTheme(context).countTextStyle)
        .copyWith(color: color);

    var child = _buildIcon(color);

    if (expanded) {
      child = Row(
        children: [
          child,
          if (showCount) ...[
            const SizedBox(width: 8),
            Expanded(
              child: DefaultTextStyle.merge(
                style: textStyle,
                child: Text(
                  shortenedCount,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
            ),
          ],
        ],
      );
    }

    final button = TextButton(
      onPressed: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      focusNode: focusNode,
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        shape: const StadiumBorder(),
        enableFeedback: enabled,
        minimumSize: Size(
          (expanded && showCount) ? 88.0 : 0.0,
          40.0,
        ),
        visualDensity: VisualDensity.comfortable,
      ),
      child: child,
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip,
        child: button,
      );
    }

    return button;
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
    final theme = Theme.of(context);

    if (!enabled || onTap == null) return theme.colorScheme.outlineVariant;

    final defaultInactiveColor = theme.getEmphasisColor(EmphasisColor.medium);
    final inactiveColor = color ?? defaultInactiveColor;

    if (active) return activeColor ?? inactiveColor;

    return inactiveColor;
  }
}
