import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/user/user.dart";
import "package:kaiteki/utils/extensions.dart";

class UserDisplayNameWidget extends ConsumerWidget {
  final User user;
  final Axis? orientation;

  const UserDisplayNameWidget(
    this.user, {
    super.key,
    this.orientation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = DisplayNameTuple.fromUser(
      user,
      orientation == Axis.vertical,
    );
    const primaryTextStyle = TextStyle(fontWeight: FontWeight.bold);
    final textSpacing = !content.separate ? 0.0 : 6.0;

    return buildFlowWidget([
      Text.rich(
        user.renderText(context, ref, content.primary),
        style: primaryTextStyle,
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      SizedBox(width: textSpacing),
      if (content.secondary != null)
        Text(
          content.secondary!,
          style: TextStyle(color: Theme.of(context).disabledColor),
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
    ]);
  }

  Widget buildFlowWidget(List<Widget> children) {
    switch (orientation) {
      case Axis.horizontal:
        return Row(children: children);
      case Axis.vertical:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        );
      default:
        return OverflowBar(children: children);
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
