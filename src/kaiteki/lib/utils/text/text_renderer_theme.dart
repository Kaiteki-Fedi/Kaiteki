import 'package:flutter/widgets.dart';
import 'package:kaiteki/di.dart';

class TextRendererTheme {
  final TextStyle linkTextStyle;
  final double emojiScale;

  const TextRendererTheme(this.linkTextStyle, this.emojiScale);

  factory TextRendererTheme.fromContext(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider).current;

    return TextRendererTheme(
      theme.linkTextStyle,
      1.5,
    );
  }
}
