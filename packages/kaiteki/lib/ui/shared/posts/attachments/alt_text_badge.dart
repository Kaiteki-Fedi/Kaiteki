import "package:flutter/material.dart";
import "package:kaiteki/theming/text_theme.dart";

/// A decorative badge that indicates the existence of an alt text.
class AltTextBadge extends StatelessWidget {
  const AltTextBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.colorScheme.inverseSurface;
    final foreground = theme.colorScheme.onInverseSurface;
    final monospaceTextStyle = theme.ktkTextTheme?.monospaceTextStyle ??
        DefaultKaitekiTextTheme(context).monospaceTextStyle;

    return IgnorePointer(
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: background,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: DefaultTextStyle(
              style: TextStyle(color: foreground),
              // ignore: l10n
              child: Text("ALT", style: monospaceTextStyle),
            ),
          ),
        ),
      ),
    );
  }
}
