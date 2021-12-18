import 'package:flutter/widgets.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/utils/utils.dart';
import 'package:provider/provider.dart';

class TextRendererTheme {
  final TextStyle linkTextStyle;
  final double emojiSize;

  const TextRendererTheme(this.linkTextStyle, this.emojiSize);

  factory TextRendererTheme.fromContext(BuildContext context) {
    final themeContainer = Provider.of<ThemeContainer>(context);
    final theme = themeContainer.current;

    return TextRendererTheme(
      theme.linkTextStyle,
      Utils.getLocalFontSize(context) * 1.5,
    );
  }
}
