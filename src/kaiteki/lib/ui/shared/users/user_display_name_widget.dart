import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";

class UserDisplayNameWidget extends ConsumerWidget {
  final User user;
  final Axis orientation;

  const UserDisplayNameWidget(
    this.user, {
    super.key,
    this.orientation = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = DisplayNameTuple.fromUser(
      user,
      orientation == Axis.vertical,
    );
    const primaryTextStyle = TextStyle(fontWeight: FontWeight.bold);
    final textSpacing = !content.separate ? 0.0 : 6.0;
    final secondaryText = content.secondary;
    final disabledColor =
        Theme.of(context).getEmphasisColor(EmphasisColor.disabled);

    switch (orientation) {
      case Axis.horizontal:
        return Text.rich(
          TextSpan(
            children: [
              user.renderText(context, ref, content.primary),
              if (secondaryText != null) ...[
                WidgetSpan(child: SizedBox(width: textSpacing)),
                TextSpan(
                  text: secondaryText,
                  style: TextStyle(color: disabledColor),
                ),
              ],
            ],
            style: primaryTextStyle,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        );
      case Axis.vertical:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              user.renderText(context, ref, content.primary),
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
            if (secondaryText != null)
              Text(
                secondaryText,
                style: disabledColor.textStyle,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
          ],
        );
    }
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
