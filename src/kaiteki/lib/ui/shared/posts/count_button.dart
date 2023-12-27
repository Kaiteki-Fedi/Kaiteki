import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
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
  final bool expanded;

  final String? label;
  final CountButtonLabelStyle? labelStyle;

  final String? semanticsLabel;

  const CountButton({
    super.key,
    required this.icon,
    this.activeColor,
    this.activeIcon,
    this.color,
    this.count,
    this.enabled = true,
    this.active = false,
    this.focusNode,
    this.onLongPress,
    this.onTap,
    this.expanded = true,
    this.animate,
    this.label,
    this.labelStyle = CountButtonLabelStyle.count,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _getColor(context);
    final count = this.count;

    final textStyle = (Theme.of(context).ktkTextTheme?.countTextStyle ??
            DefaultKaitekiTextTheme(context).countTextStyle)
        .copyWith(color: color);

    final label = switch (labelStyle) {
      CountButtonLabelStyle.none => null,
      CountButtonLabelStyle.count when count != null =>
        NumberFormat.compact().format(count).toLowerCase(),
      _ => this.label
    };

    var child = _buildIcon(color);

    if (expanded) {
      child = Row(
        children: [
          child,
          if (label != null) ...[
            const SizedBox(width: 8),
            Expanded(
              child: DefaultTextStyle.merge(
                style: textStyle,
                child: Text(
                  label,
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

    Widget widget = TextButton(
      onPressed: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      focusNode: focusNode,
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        shape: const StadiumBorder(),
        enableFeedback: enabled,
        minimumSize: Size(
          (expanded && labelStyle != CountButtonLabelStyle.none) ? 88.0 : 0.0,
          40.0,
        ),
        visualDensity: VisualDensity.comfortable,
      ),
      child: child,
    );

    if (this.label != null) {
      widget = Tooltip(
        message: this.label,
        child: widget,
      );
    }

    if (semanticsLabel != null) {
      widget = Semantics(
        label: semanticsLabel,
        button: true,
        excludeSemantics: true,
        child: widget,
      );
    }

    return widget;
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
      data: IconThemeData(color: color, size: 20.0),
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

enum CountButtonLabelStyle {
  /// Show no label at all (icon only)
  none,

  /// Show count as label
  count,

  /// Show associated label/tooltip as label
  label,
}
