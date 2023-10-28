import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/emoji/emoji_theme.dart";
import "package:kaiteki_core/model.dart";

const _defaultEmojiSize = 24.0;

/// A widget that displays an emoji.
class EmojiWidget extends StatelessWidget {
  final Emoji emoji;
  final double? size;
  final bool? square;

  const EmojiWidget(
    this.emoji, {
    super.key,
    this.size,
    this.square,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<EmojiTheme>();
    final size = this.size ?? theme?.size ?? _defaultEmojiSize;

    if (emoji is CustomEmoji) {
      return buildCustomEmoji(context, emoji as CustomEmoji);
    }

    if (emoji is UnicodeEmoji) {
      return buildUnicodeEmoji(context, emoji as UnicodeEmoji);
    }

    assert(true);

    return PlaceholderEmoji(size: size);
  }

  Widget buildCustomEmoji(BuildContext context, CustomEmoji customEmoji) {
    final theme = Theme.of(context).extension<EmojiTheme>();
    final square = this.square ?? theme?.square ?? true;
    final size = this.size ?? theme?.size ?? _defaultEmojiSize;

    return Image.network(
      customEmoji.url.toString(),
      width: square ? size : null,
      height: size,
      fit: BoxFit.contain,
      cacheHeight: (size * MediaQuery.devicePixelRatioOf(context)).toInt(),
      semanticLabel: "Emoji $emoji",
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return PlaceholderEmoji(size: size);
      },
      errorBuilder: (_, __, ___) => PlaceholderEmoji(size: size),
      isAntiAlias: true,
    );
  }

  Widget buildUnicodeEmoji(BuildContext context, UnicodeEmoji unicodeEmoji) {
    final theme = Theme.of(context).extension<EmojiTheme>();
    final size = this.size ?? theme?.size ?? _defaultEmojiSize;

    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        child: Text(unicodeEmoji.short, style: kEmojiTextStyle),
      ),
    );
  }
}

class PlaceholderEmoji extends StatelessWidget {
  final double size;

  const PlaceholderEmoji({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Theme.of(context).colorScheme.onSurface.withOpacity(.125),
      ),
      child: SizedBox.square(dimension: size),
    );
  }
}
