import "dart:ui";

import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki_core/utils.dart";

@immutable
class EmojiTheme extends ThemeExtension<EmojiTheme> {
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

  @override
  ThemeExtension<EmojiTheme> copyWith({double? size, bool? square}) {
    return EmojiTheme(
      size: size ?? this.size,
      square: square ?? this.square,
    );
  }
}

class TextInheritedEmojiTheme extends ConsumerWidget {
  final Widget child;

  const TextInheritedEmojiTheme({super.key, required this.child});

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
