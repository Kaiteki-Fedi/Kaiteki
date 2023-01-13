import "package:flutter/material.dart";
import "package:kaiteki/fediverse/model/emoji/emoji.dart";
import "package:kaiteki/ui/shared/emoji/emoji_widget.dart";

class EmojiButton extends StatelessWidget {
  final Emoji emoji;
  final double size;
  final VoidCallback? onTap;

  const EmojiButton(
    this.emoji, {
    super.key,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: EmojiWidget(emoji: emoji, size: size),
      onPressed: onTap,
      splashRadius: size * 0.75,
      iconSize: size,
    );
  }
}
