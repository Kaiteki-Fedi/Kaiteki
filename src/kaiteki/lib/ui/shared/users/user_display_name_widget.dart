import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";

class UserDisplayNameWidget extends ConsumerWidget {
  final User user;
  final Axis orientation;
  final TextStyle? secondaryTextStyle;

  const UserDisplayNameWidget(
    this.user, {
    super.key,
    this.secondaryTextStyle,
    this.orientation = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = DisplayNameTuple.fromUser(
      user,
      orientation == Axis.vertical,
    );
    final primaryTextStyle = Theme.of(context).textTheme.titleSmall;
    final textSpacing = !content.separate ? 0.0 : 6.0;

    final secondaryText = content.secondary;
    final secondaryColor =
        Theme.of(context).getEmphasisColor(EmphasisColor.disabled);
    final secondaryTextStyle =
        this.secondaryTextStyle?.copyWith(color: secondaryColor) ??
            secondaryColor.textStyle;

    Widget widget = switch (orientation) {
      Axis.horizontal => RepaintBoundary(
          child: Text.rich(
            TextSpan(
              children: [
                user.renderText(context, ref, content.primary),
                if (secondaryText != null) ...[
                  TextSpan(text: " "),
                  TextSpan(
                    text: secondaryText,
                    style: secondaryTextStyle,
                  ),
                ],
              ],
              style: primaryTextStyle,
            ),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ),
      Axis.vertical => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RepaintBoundary(
              child: Text.rich(
                user.renderText(context, ref, content.primary),
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
            if (secondaryText != null)
              Text(
                secondaryText,
                style: secondaryTextStyle,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
          ],
        )
    };

    String getSemanticsLabel() {
      if (ref.watch(readDisplayNameOnly).value) {
        return user.displayName ?? user.username;
      }

      final tuple = DisplayNameTuple.fromUser(user);
      return [tuple.primary, tuple.secondary].join("\n");
    }

    return Semantics(
      label: getSemanticsLabel(),
      excludeSemantics: true,
      child: widget,
    );
  }
}

class DisplayNameTuple {
  final String primary;
  final String? secondary;
  final bool separate;

  const DisplayNameTuple(this.primary, this.secondary, this.separate);

  factory DisplayNameTuple.fromUser(
    User user, [
    bool forceShowUsername = false,
  ]) {
    final username = user.username;
    final display = user.displayName ?? username;
    final host = user.host;
    final handle = user.handle;

    if (!forceShowUsername) {
      final normalizedDisplay = display.toLowerCase().trim();

      final similarToHandle = [
        handle.toString().toLowerCase(),
        handle.toString(false).toLowerCase(),
        username.toLowerCase(),
      ];

      if (similarToHandle.contains(normalizedDisplay)) {
        return DisplayNameTuple(username, "@$host", false);
      }
    }

    return DisplayNameTuple(
      display,
      handle.toString(),
      true,
    );
  }
}
