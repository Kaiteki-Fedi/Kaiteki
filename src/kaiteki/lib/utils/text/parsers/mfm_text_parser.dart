import 'package:kaiteki/utils/text/elements.dart';
import 'package:kaiteki/utils/text/parsers/text_parser.dart';
import 'package:kaiteki/utils/text/text_renderer.dart';

class MfmTextParser implements TextParser {
  static final _mfmPattern = RegExp(r'\$\[(?:(\w+)(?:\.(.*?))?\s(.+?))\]');

  @override
  List<Element> parse(String text, [List<Element>? children]) {
    List<Element> elements = [TextElement(text)];

    regex(elements, _mfmPattern, (match, _) {
      final key = match.group(1)!;
      // final args = match.group(2).split(",");
      final content = match.group(3)!;

      switch (key) {
        case "x2":
          return TextElement(
            content,
            style: const TextElementStyle(scale: 2.0),
            children: children,
          );
        case "x3":
          return TextElement(
            content,
            style: const TextElementStyle(scale: 3.0),
            children: children,
          );
        case "x4":
          return TextElement(
            content,
            style: const TextElementStyle(scale: 4.0),
            children: children,
          );
        case "blur":
          return TextElement(
            content,
            style: const TextElementStyle(blur: true),
            children: children,
          );
        default:
          return TextElement(content);
      }
    });

    // if (children != null) {
    //   elements = elements.followedBy(children).toList(growable: false);
    // }

    return elements;
  }

  void regex(
    List<Element> elements,
    RegExp regex,
    RegExpMatchElementBuilder builder,
  ) {
    while (true) {
      final element = elements.last;

      if (element is! TextElement) break;

      final match = regex.firstMatch(element.text!);
      if (match == null) break;

      elements.removeLast();

      final cut = element.cut(
        match.start,
        match.end - match.start,
        (text) => builder(match, text),
      );
      elements.addAll(cut);
    }
  }
}
