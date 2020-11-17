import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:kaiteki/utils/utils.dart';
import 'package:provider/provider.dart';

class TextRendererTheme {
  final TextStyle textStyle;
  final TextStyle linkTextStyle;
  final double emojiSize;

  const TextRendererTheme(this.textStyle, this.linkTextStyle, this.emojiSize);

  factory TextRendererTheme.fromContext(BuildContext context) {
    var themeContainer = Provider.of<ThemeContainer>(context);
    var theme = themeContainer.current;

    var textTheme = theme.materialTheme.textTheme;
    var textStyle = textTheme.bodyText1;

    return TextRendererTheme(
      textStyle,
      textStyle.copyWith(
        color: theme.materialTheme.accentColor,
      ),
      Utils.getLocalFontSize(context),
    );
  }
}
