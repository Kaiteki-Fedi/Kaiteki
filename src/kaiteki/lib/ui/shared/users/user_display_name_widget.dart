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
      if (user.hasDisplayName)
        Text.rich(
          user.renderDisplayName(context, ref),
          style: primaryTextStyle,
        )
      else
        Text(user.username, style: primaryTextStyle),
      SizedBox(width: textSpacing),
      if (content.secondary != null)
        Text(
          content.secondary!,
          style: TextStyle(color: Theme.of(context).disabledColor),
          overflow: TextOverflow.fade,
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
  final String? secondary;
  final bool separate;

  const DisplayNameTuple(this.secondary, this.separate);

  factory DisplayNameTuple.fromUser(
    User user, [
    bool forceShowUsername = false,
  ]) {
    final username = user.username;
    final display = user.displayName;
    final host = user.host;

    final hasDisplay = user.hasDisplayName;
    final prefixUsername =
        (hasDisplay && (display!.toLowerCase() != username.toLowerCase())) ||
            forceShowUsername;

    String? secondary;
    if (prefixUsername) secondary = "@${user.username}";
    final prefix = secondary ?? "";
    secondary = "$prefix@$host";

    return DisplayNameTuple(secondary, prefixUsername);
  }
}
