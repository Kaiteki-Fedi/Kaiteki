import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart" hide Visibility;
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";

class PostScopeIcon extends ConsumerWidget {
  final PostScope scope;
  final bool showTooltip;

  const PostScopeIcon(
    this.scope, {
    super.key,
    this.showTooltip = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color? color;

    if (ref.watch(coloredPostVisibilities).value) {
      color = getVisibilityColor(context, scope);
    }

    Widget widget = Icon(scope.toIconData(), color: color);

    if (showTooltip) {
      widget = Tooltip(
        message: scope.toDisplayString(context.l10n),
        child: widget,
      );
    }

    return widget;
  }

  static Color getVisibilityBaseColor(PostScope value) {
    return switch (value) {
      PostScope.public => Colors.blue,
      PostScope.unlisted => Colors.green,
      PostScope.followersOnly => Colors.orange,
      PostScope.direct => Colors.red,
      PostScope.circle => Colors.cyan,
      PostScope.mutuals => Colors.purple,
      PostScope.local => Colors.blueGrey,
    };
  }

  static Color getVisibilityColor(BuildContext context, PostScope value) {
    final baseColor = getVisibilityBaseColor(value);

    return createCustomColorPalette(
      baseColor.harmonizeWith(Theme.of(context).colorScheme.primary),
      Theme.of(context).colorScheme.brightness,
    ).color;
  }
}
