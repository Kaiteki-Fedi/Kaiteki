import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/reaction.dart';
import 'package:kaiteki/ui/shared/emoji/emoji_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

// TODO(Craftplacer): maybe make this UI-only and remove interaction between adapters and
//      models?
class ReactionWidget extends ConsumerStatefulWidget {
  final Post parentPost;
  final Reaction reaction;

  const ReactionWidget({
    super.key,
    required this.parentPost,
    required this.reaction,
  });

  @override
  ConsumerState<ReactionWidget> createState() => _ReactionWidgetState();
}

class _ReactionWidgetState extends ConsumerState<ReactionWidget> {
  @override
  Widget build(BuildContext context) {
    const textPadding = EdgeInsets.only(top: 4, bottom: 4, left: 6, right: 2);
    const emojiSize = 24.0;

    final reacted = widget.reaction.includesMe;
    final theme = context.getKaitekiTheme()!.reactionButtonTheme;
    final backgroundColor = reacted //
        ? theme.activeBackground
        : theme.inactiveBackground;
    final textStyle = reacted ? theme.activeTextStyle : theme.inactiveTextStyle;

    return Card(
      color: backgroundColor,
      child: DefaultTextStyle(
        style: textStyle,
        child: InkWell(
          onTap: () async {
            final adapter = ref.watch(accountProvider).adapter;
            if (adapter is ReactionSupport) {
              await (adapter as ReactionSupport).addReaction(
                widget.parentPost,
                widget.reaction.emoji,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Your instance does not support reactions."),
                ),
              );
            }
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
