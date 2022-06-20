import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

class MetaBar extends StatelessWidget {
  const MetaBar({
    Key? key,
    required this.renderedAuthor,
    required Post post,
    this.authorTextStyle,
    this.showAvatar = false,
  })  : _post = post,
        super(key: key);

  final InlineSpan renderedAuthor;
  final Post _post;
  final TextStyle? authorTextStyle;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final visibility = _post.visibility;
    final secondaryText = _getSecondaryUserText(_post.author);
    final secondaryColor = Theme.of(context).disabledColor;
    final secondaryTextTheme = TextStyle(color: secondaryColor);
    var textSpacing = 0.0;

    if (showAvatar) {
      textSpacing = 0.0;
    } else if (!_equalUserName(_post.author)) {
      textSpacing = 6.0;
    }

    return Padding(
      padding: kPostPadding.copyWith(top: 0),
      child: Row(
        children: [
          if (showAvatar)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AvatarWidget(_post.author, size: 40),
            ),
          Expanded(
            child: Wrap(
              direction: showAvatar ? Axis.vertical : Axis.horizontal,
              spacing: textSpacing,
              children: [
                Text.rich(renderedAuthor, style: authorTextStyle),
                if (secondaryText != null)
                  Text(
                    secondaryText,
                    style: secondaryTextTheme,
                    overflow: TextOverflow.fade,
                  ),
              ],
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
                message: visibility.toDisplayString(),
                child: Icon(
                  visibility.toIconData(),
                  size: 20,
                  color: secondaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String? _getSecondaryUserText(User user) {
    if (!showAvatar) {
      String? result;

      if (!_equalUserName(user)) {
        result = user.username;
      }

      final host = user.host;
      if (host != null) {
        result = '${result ?? ''}@$host';
      }

      return result;
    }

    return user.handle;
  }

  bool _equalUserName(User user) {
    return user.username.toLowerCase() == user.displayName.toLowerCase();
  }
}
