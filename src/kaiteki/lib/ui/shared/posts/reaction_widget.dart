import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/reaction.dart';
import 'package:kaiteki/theming/kaiteki/theme.dart';
import 'package:kaiteki/ui/shared/emoji/emoji_widget.dart';

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
    const emojiSize = 24.0;

    final reacted = widget.reaction.includesMe;
    final theme = Theme.of(context).ktkTheme!.reactionButtonTheme;
    final backgroundColor = reacted //
        ? theme.activeBackground
        : theme.inactiveBackground;
    final textStyle = reacted ? theme.activeTextStyle : theme.inactiveTextStyle;

    return Tooltip(
      richMessage: TextSpan(
        children: [
          TextSpan(
            text: widget.reaction.count.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: widget.reaction.count == 1 //
                ? " person reacted with "
                : " people reacted with ",
          ),
          TextSpan(
            text: widget.reaction.emoji.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          // HACK(Craftplacer): We're changing padding based on the M3 flag, but the better approach would be analyzing the button shape
          padding: Theme.of(context).useMaterial3
              ? const EdgeInsets.symmetric(horizontal: 12.0)
              : const EdgeInsets.symmetric(horizontal: 6.0),
        ),
        icon: EmojiWidget(
          emoji: widget.reaction.emoji,
          size: emojiSize,
        ),
        label: Text(
          widget.reaction.count.toString(),
          style: textStyle,
        ),
        onPressed: _onPressed,
      ),
    );
  }

  Future<void> _onPressed() async {
    final adapter = ref.watch(accountProvider).adapter;
    if (adapter is! ReactionSupport) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Your instance does not support reactions."),
        ),
      );
      return;
    }

    final reactionAdapter = adapter as ReactionSupport;

    if (widget.reaction.includesMe) {
      await reactionAdapter.removeReaction(
        widget.parentPost,
        widget.reaction.emoji,
      );
    } else {
      await reactionAdapter.addReaction(
        widget.parentPost,
        widget.reaction.emoji,
      );
    }
  }
}
