import 'package:flutter/painting.dart';

class PleromaThemeParser {
  /// A complete list of dynamically generated colors, don't change order
  static Iterable<_PleromaThemeMapEntry> _mapping = [
    _PleromaThemeMapEntry("bg", opacity: "bg"),
    _PleromaThemeMapEntry("fg"),
    _PleromaThemeMapEntry("text"),
    _PleromaThemeMapEntry("underlay"),
    _PleromaThemeMapEntry("link", fallback: "accent"),
    _PleromaThemeMapEntry("accent", fallback: "link"),
    _PleromaThemeMapEntry("cBlue"),
    _PleromaThemeMapEntry("cRed"),
    _PleromaThemeMapEntry("cGreen"),
    _PleromaThemeMapEntry("cOrange"),
    _PleromaThemeMapEntry("border", fallback: "fg"),
    _PleromaThemeMapEntry("fgText", fallback: "text"),
    _PleromaThemeMapEntry("fgLink", fallback: "link"),
    _PleromaThemeMapEntry("panelText", fallback: "text"),
    _PleromaThemeMapEntry("highlightText", fallback: "text"),
    _PleromaThemeMapEntry("topBar", fallback: "fg"),
    _PleromaThemeMapEntry("alertError", fallback: "cRed"),
    _PleromaThemeMapEntry("alertErrorText", fallback: "text"),
    _PleromaThemeMapEntry("alertErrorPanelText", fallback: "panelText"),
    _PleromaThemeMapEntry("btn", fallback: "fg"),
    _PleromaThemeMapEntry("btnText", fallback: "fgText"),
    // v- alphaBlend(btn,0.25,bg)
    _PleromaThemeMapEntry("btnDisabled", fallback: "btn"),
    // v- brightness(5 * mod, bg).rgb
    _PleromaThemeMapEntry("selectedMenu", fallback: "bg"),
    _PleromaThemeMapEntry("selectedMenuText", fallback: "highlightText"),
    // v- mixrgb(bg, text)
    _PleromaThemeMapEntry("selectedMenuIcon", fallback: "selectedMenuText"),
    _PleromaThemeMapEntry("popover", fallback: "bg"),
    _PleromaThemeMapEntry("popoverText", fallback: "text"),
    _PleromaThemeMapEntry("chatBg", fallback: "bg"),
    _PleromaThemeMapEntry("chatMessageIncomingBg", fallback: "chatBg"),
    _PleromaThemeMapEntry("chatMessageIncomingText", fallback: "text"),
    _PleromaThemeMapEntry("chatMessageIncomingLink", fallback: "link"),
    _PleromaThemeMapEntry("chatMessageIncomingBorder", fallback: "border"),
    _PleromaThemeMapEntry("chatMessageOutgoingBg",
        fallback: "chatMessageIncomingBg"),
    _PleromaThemeMapEntry("chatMessageOutgoingText", fallback: "text"),
    _PleromaThemeMapEntry("chatMessageOutgoingLink", fallback: "link"),
    _PleromaThemeMapEntry("chatMessageOutgoingBorder",
        fallback: "chatMessageOutgoingBg"),
  ];

  static Map<String, Color> parseColors(Map<String, String> hexMap) {
    return hexMap.map((key, hex) => MapEntry(key, _hexToColor(hex)));
  }

  static Map<String, Color> resolveColors(
    Map<String, Color> colors,
    Map<String, double> opacities,
  ) {
    var result = <String, Color>{};

    _mapping.forEach((entry) {
      Color color;

      if (colors.containsKey(entry.key)) {
        color = colors[entry.key];
      } else if (result.containsKey(entry.fallback)) {
        color = result[entry.fallback];
      }

      // stop applying transformations to color if null
      if (color == null) return null;

      // apply opacity if available
      if (opacities.containsKey(entry.opacity)) {
        color = color.withOpacity(opacities[entry.opacity]);
      }

      result[entry.key] = color;
    });

    return colors;
  }

  static Color _hexToColor(String code) {
    code = code.substring(1, 7);
    return new Color(int.parse(code, radix: 16) + 0xFF000000);
  }
}

class _PleromaThemeMapEntry {
  final String key;
  final String fallback;
  final String opacity;

  _PleromaThemeMapEntry(this.key, {this.fallback, this.opacity});
}
