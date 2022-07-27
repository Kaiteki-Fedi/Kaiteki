import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/fediverse/model/user_reference.dart';
import 'package:kaiteki/theming/kaiteki/text_theme.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/utils.dart';

class ReplyBar extends ConsumerWidget {
  const ReplyBar({
    super.key,
    this.textStyle,
    required this.post,
  });

  final TextStyle? textStyle;
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disabledColor = Theme.of(context).disabledColor;
    final l10n = context.getL10n();
    final adapter = ref.watch(accountProvider).adapter;

    return Padding(
      padding: kPostPadding,
      child: FutureBuilder<User?>(
        future: UserReference(_getUserId()).resolve(adapter),
        builder: (context, snapshot) {
          final span = snapshot.hasData
              ? snapshot.data!.renderDisplayName(context, ref)
              : TextSpan(
                  text: _getText(),
                  style: Theme.of(context).ktkTextTheme!.linkTextStyle,
                );

          return Text.rich(
            TextSpan(
              style: textStyle,
              children: [
                // TODO(Craftplacer): refactor the following widget pattern to a future "IconSpan"
                WidgetSpan(
                  child: Directionality(
                    textDirection: Directionality.of(context).inverted,
                    child: Icon(
                      Icons.reply_rounded,
                      size: getLocalFontSize(context) * 1.25,
                      color: disabledColor,
                    ),
                  ),
                ),
                TextSpan(
                  text: ' ${l10n.replyTo} ',
                  style: TextStyle(color: disabledColor),
                ),
                span,
              ],
            ),
          );
        },
      ),
    );
  }

  String _getText() {
    final user = post.replyToUser;
    if (user != null) {
      return '@${user.username}';
    }

    final id = post.replyToUserId;
    if (id != null) {
      return id;
    }

    return "unknown user";
  }

  String _getUserId() {
    if (post.replyToUserId != null) return post.replyToUserId!;
    if (post.replyTo != null) return post.replyTo!.author.id;
    throw Exception("Can't find user id as reply");
  }
}
