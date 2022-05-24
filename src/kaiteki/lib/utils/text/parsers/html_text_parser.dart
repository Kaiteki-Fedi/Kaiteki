import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parseFragment;
import 'package:kaiteki/fediverse/model/user_reference.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/text/elements.dart';
import 'package:kaiteki/utils/text/parsers.dart';

typedef HtmlElementConstructor = Element Function(
  dom.Element element,
  List<Element> subElements,
);

class HtmlTextParser implements TextParser {
  static final _logger = getLogger("HtmlTextParser");

  @override
  List<Element> parse(String text, [List<Element>? children]) {
    final fragment = parseFragment(text);
    return fragment.nodes.map<Element>(renderNode).toList(growable: false);
  }

  late final Map<String, HtmlElementConstructor> htmlConstructors;

  HtmlTextParser() {
    htmlConstructors = {
      "a": _renderLink,
      "br": _renderBreakLine,
      "pre": _renderCodeFont,
      "code": _renderCodeFont,
      "p": _renderParagraph,
      "i": _renderItalic,
      "b": _renderBold,
      "span": _renderAsContainer,
    };
  }

  Element renderNode(dom.Node node) {
    final renderedSubNodes = node.nodes //
        .map<Element>(renderNode)
        .toList(growable: false);

    if (node is dom.Element) {
      final override = renderNodeOverride(node);
      if (override != null) return override;

      final tag = node.localName!.toLowerCase();
      final constructor = htmlConstructors[tag];
      if (constructor != null) {
        return constructor.call(node, renderedSubNodes);
      } else {
        _logger.w("Unhandled HTML tag ($tag), returning it as TextElement.");
      }
    }
    // else if (node is dom.Text) {
    //  return TextElement(node.text, children: renderedSubNodes);
    //}

    if (node.text == null) {
      return Element(children: renderedSubNodes);
    } else {
      return TextElement(node.text, children: renderedSubNodes);
    }
  }

  Element? renderNodeOverride(dom.Node node) {
    return null;
  }

  Element _renderLink(dom.Element element, List<Element> subElements) {
    final uri = Uri.parse(element.attributes["href"]!);
    return LinkElement(uri, children: subElements);
  }

  Element _renderBreakLine(dom.Element element, List<Element> subElements) {
    return const TextElement("\n");
  }

  Element _renderCodeFont(dom.Element element, List<Element> subElements) {
    return TextElement(
      null,
      style: const TextElementStyle(font: TextElementFont.monospace),
      children: subElements,
    );
  }

  Element _renderItalic(dom.Element element, List<Element> subElements) {
    return TextElement(
      null,
      style: const TextElementStyle(italic: true),
      children: subElements,
    );
  }

  Element _renderBold(dom.Element element, List<Element> subElements) {
    return TextElement(
      null,
      style: const TextElementStyle(bold: true),
      children: subElements,
    );
  }

  Element _renderParagraph(dom.Element element, List<Element> subElements) {
    var text = "";

    if (element.previousElementSibling?.localName?.toLowerCase() == "p") {
      text = "\n\n$text";
    }

    return TextElement(text, children: subElements);
  }

  Element _renderAsContainer(dom.Element element, List<Element> subElements) {
    if (subElements.length == 1) {
      return subElements.first;
    } else {
      return Element(children: subElements);
    }
  }
}

class MastodonHtmlTextParser extends HtmlTextParser {
  @override
  Element? renderNodeOverride(dom.Node node) {
    if (node.hasClass("h-card")) {
      final link = node.firstChild;

      if (link != null) {
        final result = renderNodeOverride(link);
        if (result != null) return result;
      }
    }

    final url = node.attributes["href"];
    if (url != null) {
      if (node.hasClass("mention")) {
        return MentionElement(UserReference.url(url));
      }
    }

    if (node.hasClass("hashtag")) {
      final name = node.attributes["data-tag"];
      if (name != null) {
        return HashtagElement(name);
      }
    }

    return null;
  }
}
