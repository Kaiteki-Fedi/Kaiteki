import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/corner_painter.dart";
import "package:kaiteki/ui/shared/emoji/emoji_widget.dart";
import "package:kaiteki_core/model.dart";

class EmojiButton extends StatelessWidget {
  final Emoji emoji;
  final double? size;
  final bool? square;
  final VoidCallback? onTap;
  final VoidCallback? onLongTap;

  const EmojiButton(
    this.emoji, {
    super.key,
    this.size,
    this.square,
    required this.onTap,
    this.onLongTap,
  });

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: EmojiWidget(emoji, size: size, square: square),
      onPressed: onTap,
      iconSize: size,
    );

    if (onLongTap != null) {
      return GestureDetector(
        onLongPress: onLongTap,
        child: Stack(
          children: [
            Positioned(
              bottom: 4,
              right: 4,
              width: 8,
              height: 8,
              child: CustomPaint(
                painter: CornerPainter(
                  Corner.bottomRight,
                  Paint()..color = Theme.of(context).disabledColor,
                ),
              ),
            ),
            button,
          ],
        ),
      );
    }

    return button;
  }
}
