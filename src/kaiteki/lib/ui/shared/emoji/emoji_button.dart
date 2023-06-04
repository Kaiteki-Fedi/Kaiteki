import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/emoji/emoji_widget.dart";
import "package:kaiteki_core/model.dart";

class EmojiButton extends StatelessWidget {
  final Emoji emoji;
  final double? size;
  final bool? square;
  final VoidCallback? onTap;

  const EmojiButton(
    this.emoji, {
    super.key,
    this.size,
    this.square,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: EmojiWidget(emoji, size: size, square: square),
      onPressed: onTap,
      iconSize: size,
    );
  }
}
