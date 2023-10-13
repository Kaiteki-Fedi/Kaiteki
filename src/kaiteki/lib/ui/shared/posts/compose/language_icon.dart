import "package:flutter/material.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";

class LanguageIcon extends StatelessWidget {
  const LanguageIcon(this.language, {super.key});

  final String language;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: IconTheme.of(context).color,
      ),
      child: Text(
        language.toUpperCase(),
        style: theme.ktkTextTheme?.monospaceTextStyle ??
            DefaultKaitekiTextTheme(context).monospaceTextStyle,
      ),
    );
  }
}
