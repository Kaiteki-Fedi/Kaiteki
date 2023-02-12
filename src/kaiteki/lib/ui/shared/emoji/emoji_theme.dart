import "dart:ui";

import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:mek_data_class/mek_data_class.dart";

part "emoji_theme.g.dart";

@immutable
@DataClass(copyable: true)
class EmojiTheme extends ThemeExtension<EmojiTheme> with _$EmojiTheme {
  // The size of the emoji.
  final double size;

  // Whether to constrain the width to the emoji size.
  final bool square;

  const EmojiTheme({this.size = 24.0, this.square = true});

  @override
  EmojiTheme lerp(covariant EmojiTheme? other, double t) {
    if (other == null) return this;

    return EmojiTheme(
      size: lerpDouble(size, other.size, t)!,
      square: t >= 0.5 ? other.square : square,
    );
  }
}

class TextInheritedEmojiTheme extends ConsumerWidget {
  final Widget child;

  const TextInheritedEmojiTheme({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final emojiTheme = theme.extension<EmojiTheme>() ?? const EmojiTheme();
    final size = DefaultTextStyle.of(context).style.fontSize.nullTransform(
          (fontSize) => ref.watch(emojiScale).value * fontSize,
        );

    return Theme(
      data: theme.copyWith(
        extensions: [
          ...theme.extensions.values,
          emojiTheme.copyWith(size: size),
        ],
      ),
      child: child,
    );
  }
}
