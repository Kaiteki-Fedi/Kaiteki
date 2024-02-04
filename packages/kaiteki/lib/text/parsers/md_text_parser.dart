import "package:kaiteki/text/elements.dart";
import "package:kaiteki/text/parsers/html_text_parser.dart";
import "package:kaiteki/text/parsers/text_parser.dart";
import "package:markdown/markdown.dart" show markdownToHtml;

class MarkdownTextParser implements TextParser {
  final HtmlTextParser htmlTextParser;

  const MarkdownTextParser([this.htmlTextParser = const HtmlTextParser()]);

  @override
  Iterable<Element> parse(String text) sync* {
    final html = markdownToHtml(text, inlineOnly: true);
    yield* htmlTextParser.parse(html);
  }
}
