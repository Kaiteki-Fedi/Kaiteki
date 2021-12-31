import 'package:flutter/widgets.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/utils/utils.dart';

class TextRendererTheme {
  final TextStyle linkTextStyle;
  final double emojiSize;

  const TextRendererTheme(this.linkTextStyle, this.emojiSize);

  factory TextRendererTheme.fromContext(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider).current;

    return TextRendererTheme(
      theme.linkTextStyle,
      getLocalFontSize(context) * 1.5,
    );
  }
}
