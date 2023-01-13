import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/user/user.dart";
import "package:kaiteki/utils/extensions.dart";

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
    final content = DisplayNameTuple.fromUser(user);
    const primaryTextStyle = TextStyle(fontWeight: FontWeight.bold);
    final textSpacing =
        orientation == Axis.vertical || !content.separate ? 0.0 : 6.0;

    return Wrap(
      direction: orientation,
      spacing: textSpacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (user.hasDisplayName)
          Text.rich(
            user.renderDisplayName(context, ref),
            style: primaryTextStyle,
          )
        else
          Text(user.username, style: primaryTextStyle),
        if (content.secondary != null)
          Text(
            content.secondary!,
            style: TextStyle(color: Theme.of(context).disabledColor),
            overflow: TextOverflow.fade,
          ),
      ],
    );
  }
}

class DisplayNameTuple {
  final String? secondary;
  final bool separate;

  const DisplayNameTuple(this.secondary, this.separate);

  factory DisplayNameTuple.fromUser(User user) {
    final username = user.username;
    final display = user.displayName;
    final host = user.host;

    final hasDisplay = user.hasDisplayName;
    final isSameName =
        !hasDisplay || (display!.toLowerCase() == username.toLowerCase());

    String? secondary;
    if (!isSameName) secondary = user.username;
    final prefix = secondary ?? "";
    secondary = "$prefix@$host";

    return DisplayNameTuple(secondary, !isSameName);
  }
}
