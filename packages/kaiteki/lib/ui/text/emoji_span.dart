import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/shared/emoji/emoji_theme.dart";
import "package:kaiteki/ui/shared/emoji/emoji_widget.dart";
import "package:kaiteki_core/kaiteki_core.dart";

class EmojiSpan extends WidgetSpan {
  final Emoji emoji;

  late final String _plainText;

  @override
  void computeToPlainText(
    StringBuffer buffer, {
    bool includeSemanticsLabels = true,
    bool includePlaceholders = true,
  }) {
    buffer.write(_plainText);
  }

  EmojiSpan(this.emoji, {super.alignment})
      : super(
          child: Consumer(
            child: EmojiWidget(emoji),
            builder: (context, ref, child) {
              final theme = Theme.of(context);
              final emojiTheme =
                  theme.extension<EmojiTheme>() ?? const EmojiTheme();
              final size = DefaultTextStyle.of(context).style.fontSize.andThen(
                    (fontSize) => ref.watch(emojiScale).value * fontSize,
                  );

              return Theme(
                data: theme.copyWith(
                  extensions: [
                    ...theme.extensions.values,
                    emojiTheme.copyWith(size: size),
                  ],
                ),
                child: child!,
              );
            },
          ),
        ) {
    _plainText = ":${emoji.short}:";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (super != other) return false;
    return other is EmojiSpan &&
        other.emoji == emoji &&
        other.alignment == alignment &&
        other.baseline == baseline;
  }

  /// Returns the text span that contains the given position in the text.
  @override
  InlineSpan? getSpanForPositionVisitor(
    TextPosition position,
    Accumulator offset,
  ) {
    final affinity = position.affinity;
    final targetOffset = position.offset;
    final endOffset = offset.value + _plainText.length;
    if (offset.value == targetOffset && affinity == TextAffinity.downstream ||
        offset.value < targetOffset && targetOffset < endOffset ||
        endOffset == targetOffset && affinity == TextAffinity.upstream) {
      return this;
    }
    offset.increment(_plainText.length);
    return null;
  }

  @override
  int? codeUnitAtVisitor(int index, Accumulator offset) {
    final localOffset = index - offset.value;
    assert(localOffset >= 0);
    offset.increment(_plainText.length);
    return localOffset < _plainText.length
        ? _plainText.codeUnitAt(localOffset)
        : null;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, emoji, alignment, baseline);
}
