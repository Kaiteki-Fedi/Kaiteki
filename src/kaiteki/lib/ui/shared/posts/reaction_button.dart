import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/model.dart';
import 'package:kaiteki/theming/kaiteki/theme.dart';
import 'package:kaiteki/ui/shared/emoji/emoji_widget.dart';

class ReactionButton extends StatelessWidget {
  final Reaction reaction;
  final VoidCallback onPressed;

  const ReactionButton({
    super.key,
    required this.onPressed,
    required this.reaction,
  });

  @override
  Widget build(BuildContext context) {
    const emojiSize = 24.0;

    final reacted = reaction.includesMe;
    final theme = Theme.of(context).ktkTheme!.reactionButtonTheme;
    final backgroundColor = reacted //
        ? theme.activeBackground
        : theme.inactiveBackground;
    final textStyle = reacted ? theme.activeTextStyle : theme.inactiveTextStyle;

    var count = reaction.count;

    if (reacted) count--;

    return Tooltip(
      richMessage: TextSpan(
        children: [
          if (reacted) ...[
            const TextSpan(
              text: "You",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
          if (reacted && count != 0) ...[const TextSpan(text: " and ")],
          if (count != 0) ...[
            TextSpan(
              text: count.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: reaction.count == 1 //
                  ? " person"
                  : " people",
            ),
          ],
          const TextSpan(text: " reacted with "),
          TextSpan(
            text: _getEmojiText(reaction.emoji),
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
          emoji: reaction.emoji,
          size: emojiSize,
        ),
        label: Text(
          reaction.count.toString(),
          style: textStyle,
        ),
        onPressed: onPressed,
      ),
    );
  }

  String _getEmojiText(Emoji emoji) {
    if (emoji is UnicodeEmoji) return emoji.emoji;
    return emoji.toString();
  }
}
