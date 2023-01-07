import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/emoji/emoji.dart';

/// A widget that displays an emoji.
class EmojiWidget extends StatelessWidget {
  final Emoji emoji;
  final double size;

  const EmojiWidget({
    super.key,
    required this.emoji,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (emoji is CustomEmoji) return buildCustomEmoji(emoji as CustomEmoji);

    if (emoji is UnicodeEmoji) return buildUnicodeEmoji(emoji as UnicodeEmoji);

    throw UnimplementedError(
      "There's no implementation for $emoji in EmojiWidget. Can't build.",
    );
  }

  Widget buildCustomEmoji(CustomEmoji customEmoji) {
    return Image.network(
      customEmoji.url,
      width: size,
      height: size,
      fit: BoxFit.contain,
      // cacheHeight: size.toInt(),
      semanticLabel: "Emoji $emoji",
      loadingBuilder: (_, widget, event) => event == null //
          ? widget
          : PlaceholderEmoji(size: size),
      errorBuilder: (_, __, ___) => PlaceholderEmoji(size: size),
    );
  }

  Widget buildUnicodeEmoji(UnicodeEmoji unicodeEmoji) {
    const textStyle = TextStyle(
      fontFamily: "Noto Color Emoji",
      fontFamilyFallback: ["Segoe UI Emoji"],
    );

    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        child: Text(
          unicodeEmoji.short,
          style: textStyle,
        ),
      ),
    );
  }
}

class PlaceholderEmoji extends StatelessWidget {
  final double size;

  const PlaceholderEmoji({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    const padding = 0.0;
    final finalSize = size - (padding * 2);

    // return DecoratedBox(
    //   decoration: BoxDecoration(
    //     shape: BoxShape.circle,
    //     color: Theme.of(context).disabledColor,
    //   ),
    //   child: SizedBox.square(dimension: size),
    // );

    return Padding(
      // ignore: use_named_constants
      padding: const EdgeInsets.all(padding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Theme.of(context).colorScheme.onSurface.withOpacity(.125),
        ),
        child: SizedBox.square(dimension: finalSize),
      ),
    );
  }
}
