import "dart:ui";

import "package:kaiteki/text/elements.dart";
import "package:kaiteki/text/parsers/text_parser.dart";
import "package:logging/logging.dart";
import "../mfm_parser.dart" as mfm;

class MfmTextParser implements TextParser {
  static final _logger = Logger("MfmTextParser");

  const MfmTextParser();

  @override
  Iterable<Element> parse(String text) sync* {
    var previousEnd = 0;

    for (final region in mfm.parse(text)) {
      if (region.start - previousEnd > 0) {
        yield TextElement(text.substring(previousEnd, region.start));
      }

      yield* _partToElement(region);

      previousEnd = region.end;
    }

    if (text.length - previousEnd > 0) {
      yield TextElement(text.substring(previousEnd, text.length));
    }
  }

  Iterable<Element> _partToElement(mfm.Region part) sync* {
    // There should be a fast-path for avoiding parsing the content if the MFM
    // tag itself is not supported.
    final children = parse(part.content);

    Color? tryParseColor() {
      var hex = part.args["color"];
      if (hex == null || hex.length < 6) return null;
      if (hex.length < 8) hex = "FF$hex";
      return Color(int.parse(hex, radix: 16));
    }

    const styleX2 = TextElementStyle(scale: 2.0);
    const styleX3 = TextElementStyle(scale: 3.0);
    const styleX4 = TextElementStyle(scale: 4.0);
    const styleBlur = TextElementStyle(blur: true);

    switch (part.tag) {
      case "x2":
        yield TextStyleElement(styleX2, children.toList());
      case "x3":
        yield TextStyleElement(styleX3, children.toList());
      case "x4":
        yield TextStyleElement(styleX4, children.toList());
      case "blur":
        yield TextStyleElement(styleBlur, children.toList());
      case "fg" when part.args["color"] != null:
        yield TextStyleElement(
          TextElementStyle(foreground: tryParseColor()),
          children.toList(),
        );
      case "bg" when part.args["color"] != null:
        yield TextStyleElement(
          TextElementStyle(background: tryParseColor()),
          children.toList(),
        );
      case "font" when part.args.containsKey("monospace"):
        yield TextStyleElement(
          TextElementStyle.kMonospace,
          children.toList(),
        );
      case "scale":
      case "rotate":
      case "jelly":
      case "tada":
      case "jump":
      case "bounce":
      case "spin":
      case "shake":
      case "twitch":
      case "rainbow":
      case "fade":
      case "position":
        yield* children;
      default:
        _logger.warning("Unsupported MFM tag: ${part.tag}");
        yield TextElement(part.content);
    }
  }
}
