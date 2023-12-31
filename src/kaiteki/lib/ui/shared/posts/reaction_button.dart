import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/text_theme.dart";
import "package:kaiteki/ui/shared/emoji/emoji_widget.dart";
import "package:kaiteki_core/model.dart";

class ReactionButton extends ConsumerWidget {
  final Reaction reaction;
  final VoidCallback onPressed;

  const ReactionButton({
    super.key,
    required this.onPressed,
    required this.reaction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dense = ref.watch(AppExperiment.denseReactions.provider);
    final emojiSize = dense ? 16.0 : 24.0;

    final reacted = reaction.includesMe;
    final theme = Theme.of(context);
    final backgroundColor = reacted ? theme.colorScheme.inverseSurface : null;

    final foregroundColor = reacted
        ? theme.colorScheme.onInverseSurface
        : theme.colorScheme.onSurfaceVariant;

    final textStyle = theme.ktkTextTheme?.countTextStyle ??
        DefaultKaitekiTextTheme(context).countTextStyle;

    var count = reaction.count;

    if (reacted) count--;

    final outlineColor = theme.colorScheme.outline;
    return Tooltip(
      richMessage: TextSpan(
        children: [
          TextSpan(
            text: count.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: reaction.count == 1 //
                ? " person"
                : " people",
          ),
          const TextSpan(text: " reacted with "),
          TextSpan(
            text: _getEmojiText(reaction.emoji),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      child: MaterialButton(
        color: backgroundColor,
        onPressed: onPressed,
        visualDensity: VisualDensity.compact,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: reacted ? BorderSide.none : BorderSide(color: outlineColor),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: emojiSize + 40,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextStyle.merge(
              style: TextStyle(color: foregroundColor),
              child: EmojiWidget(
                reaction.emoji,
                size: emojiSize,
              ),
            ),
            if (ref.watch(showReactionCounts).value) ...[
              const SizedBox(width: 6),
              Text(
                reaction.count.toString(),
                style: textStyle.copyWith(color: foregroundColor),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getEmojiText(Emoji emoji) {
    if (emoji is UnicodeEmoji) return emoji.emoji;
    return emoji.toString();
  }
}
