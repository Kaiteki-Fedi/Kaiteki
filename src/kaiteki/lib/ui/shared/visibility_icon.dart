import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart" hide Visibility;
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";

class VisibilityIcon extends ConsumerWidget {
  final Visibility visibility;
  final bool showTooltip;

  const VisibilityIcon(
    this.visibility, {
    super.key,
    this.showTooltip = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color? color;

    if (ref.watch(coloredPostVisibilities).value) {
      color = getVisibilityColor(context, visibility);
    }

    Widget widget = Icon(visibility.toIconData(), color: color);

    if (showTooltip) {
      widget = Tooltip(
        message: visibility.toDisplayString(context.l10n),
        child: widget,
      );
    }

    return widget;
  }

  static Color getVisibilityBaseColor(Visibility value) {
    return switch (value) {
      Visibility.public => Colors.blue,
      Visibility.unlisted => Colors.green,
      Visibility.followersOnly => Colors.orange,
      Visibility.direct => Colors.red,
      Visibility.circle => Colors.cyan,
      Visibility.mutuals => Colors.purple,
      Visibility.local => Colors.blueGrey,
    };
  }

  static Color getVisibilityColor(BuildContext context, Visibility value) {
    final baseColor = getVisibilityBaseColor(value);

    return createCustomColorPalette(
      baseColor.harmonizeWith(Theme.of(context).colorScheme.primary),
      Theme.of(context).colorScheme.brightness,
    ).color;
  }
}
