import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/text/elements.dart';

abstract class TextParser {
  List<Element> parse(String text, [List<Element>? children]);
}

extension TextParserExtensions on TextParser {
  List<Element> parseElement(Element element) {
    if (element is TextElement) {
      final children = element.children == null
          ? <Element>[]
          : element.children!
              .map(parseElement)
              .concat()
              .toList(growable: false);

      final elements = element.text == null //
          ? children
          : parse(element.text!, children);

      if (element.style == null) {
        return elements;
      } else {
        return [TextElement(null, children: elements, style: element.style)];
      }
    } else {
      return [element];
    }
  }
}
