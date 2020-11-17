import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kaiteki/model/fediverse/emoji.dart';
import 'package:mdi/mdi.dart';

/// A widget that displays an emoji.
class EmojiWidget extends StatelessWidget {
  final Emoji emoji;
  final double size;

  const EmojiWidget({
    Key key,
    this.emoji,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (emoji is CustomEmoji) return buildCustomEmoji(emoji);

    if (emoji is UnicodeEmoji) return buildUnicodeEmoji(emoji);

    throw "There's no implementation for $emoji in EmojiWidget. Can't build.";
  }

  Widget buildCustomEmoji(CustomEmoji customEmoji) {
    return Image.network(
      customEmoji.url,
      width: size,
      height: size,
      isAntiAlias: true,
      filterQuality: FilterQuality.high,
      semanticLabel: "Emoji ${emoji.name}",
      loadingBuilder: (context, widget, event) {
        if (event == null ||
            event.cumulativeBytesLoaded == null ||
            event.expectedTotalBytes == null) {
          return widget;
        }

        var progress = event.cumulativeBytesLoaded / event.expectedTotalBytes;
        var baseColor = context == null
            ? Colors.white.withOpacity(0.5)
            : Theme.of(context).disabledColor;
        var opacityDifference = 1.0 - baseColor.opacity;
        var finalOpacity = baseColor.opacity + (progress * opacityDifference);

        print(finalOpacity);

        return Icon(
          Mdi.emoticonOutline,
          color: baseColor.withOpacity(finalOpacity),
        );
      },
      errorBuilder: (context, o, stack) {
        return Icon(
          Mdi.emoticonCry,
          color: Colors.red.withOpacity(0.25),
        );
      },
    );
  }

  Widget buildUnicodeEmoji(UnicodeEmoji unicodeEmoji) {
    return Text(
      unicodeEmoji.source,
      style: TextStyle(fontSize: size, height: size),
    );
  }
}
