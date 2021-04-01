import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/fediverse/api/adapters/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/reaction.dart';
import 'package:kaiteki/theming/app_themes/app_theme.dart';
import 'package:kaiteki/ui/widgets/emoji/emoji_widget.dart';
import 'package:provider/provider.dart';

// TODO maybe make this UI-only and remove interaction between adapters and
//      models?
class ReactionWidget extends StatefulWidget {
  final Post parentPost;
  final Reaction reaction;

  ReactionWidget({
    Key? key,
    required this.parentPost,
    required this.reaction,
  }) : super(key: key);

  @override
  _ReactionWidgetState createState() => _ReactionWidgetState();
}

class _ReactionWidgetState extends State<ReactionWidget> {
  @override
  Widget build(BuildContext context) {
    var textPadding =
        const EdgeInsets.only(top: 4, bottom: 4, left: 6, right: 2);

    var reacted = widget.reaction.includesMe;
    var theme = AppTheme.of(context);
    var backgroundColor = reacted
        ? theme.reactionActiveBackground
        : theme.reactionInactiveBackground;
    var textStyle = reacted
        ? theme.reactionActiveTextStyle
        : theme.reactionInactiveTextStyle;

    const emojiSize = 24.0;

    return Card(
      color: backgroundColor,
      child: DefaultTextStyle(
        style: textStyle,
        child: InkWell(
          onTap: () async {
            var container =
                Provider.of<AccountContainer>(context, listen: false);
            var reactiveAdapter = container.adapter as ReactionSupport;
            await reactiveAdapter.addReaction(
              widget.parentPost,
              widget.reaction.emoji,
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: textPadding,
                child: SizedBox(
                  width: emojiSize,
                  height: emojiSize,
                  child: EmojiWidget(
                    emoji: widget.reaction.emoji,
                    size: emojiSize,
                  ),
                ),
              ),
              Padding(
                padding: textPadding.flipped,
                child: Opacity(
                  opacity: 0.75,
                  child: Text(widget.reaction.count.toString()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
