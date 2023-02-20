import "package:kaiteki/text/elements.dart";
import "package:kaiteki/text/parsers/html_text_parser.dart";
import "package:kaiteki/text/parsers/text_parser.dart";
import "package:markdown/markdown.dart" show markdownToHtml;

class MarkdownTextParser implements TextParser {
  final HtmlTextParser htmlTextParser;

  const MarkdownTextParser([this.htmlTextParser = const HtmlTextParser()]);

  @override
  List<Element> parse(String text, [List<Element>? children]) {
    final html = markdownToHtml(text, inlineOnly: true);
    return htmlTextParser.parse(html, children);
  }
}
