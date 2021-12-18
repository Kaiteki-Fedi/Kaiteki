import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:mdi/mdi.dart';

/// A widget that displays an emoji.
class EmojiWidget extends StatelessWidget {
  final Emoji emoji;
  final double size;

  const EmojiWidget({
    Key? key,
    required this.emoji,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (emoji is CustomEmoji) return buildCustomEmoji(emoji as CustomEmoji);

    if (emoji is UnicodeEmoji) return buildUnicodeEmoji(emoji as UnicodeEmoji);

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
        if (event == null || event.expectedTotalBytes == null) {
          return widget;
        }

        const padding = 0.0;

        return Padding(
          padding: const EdgeInsets.all(padding),
          child: Container(
            width: size - (padding * 2),
            height: size - (padding * 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: Theme.of(context).disabledColor,
            ),
          ),
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
    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(unicodeEmoji.source!),
      ),
    );
  }
}
