import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';
import 'package:kaiteki/ui/shared/posts/user_display_name_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

class MetaBar extends StatelessWidget {
  const MetaBar({
    super.key,
    required Post post,
    this.showAvatar = false,
  }) : _post = post;

  final Post _post;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPostPadding.copyWith(top: 0),
      child: Row(
        children: [
          ...buildLeft(context),
          ...buildRight(context),
        ],
      ),
    );
  }

  List<Widget> buildLeft(BuildContext context) {
    return [
      if (showAvatar)
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: AvatarWidget(_post.author, size: 40),
        ),
      Expanded(child: UserDisplayNameWidget(_post.author)),
    ];
  }

  List<Widget> buildRight(BuildContext context) {
    final visibility = _post.visibility;
    final secondaryColor = Theme.of(context).disabledColor;
    final secondaryTextTheme = TextStyle(color: secondaryColor);
    final l10n = context.getL10n();

    return [
      if (_post.state.pinned)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Tooltip(
            message: l10n.postPinned,
            child: Icon(
              Icons.push_pin_rounded,
              size: 20,
              color: secondaryColor,
            ),
          ),
        ),
      Tooltip(
        message: _post.postedAt.toString(),
        child: Text(
          DateTime.now().difference(_post.postedAt).toStringHuman(
                context: context,
              ),
          style: secondaryTextTheme,
        ),
      ),
      if (visibility != null)
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Tooltip(
            message: visibility.toDisplayString(l10n),
            child: Icon(
              visibility.toIconData(),
              size: 20,
              color: secondaryColor,
            ),
          ),
        ),
    ];
  }
}
