import 'package:kaiteki/fediverse/model/user_reference.dart';
import 'package:kaiteki/utils/text/elements.dart';
import 'package:kaiteki/utils/text/parsers/text_parser.dart';
import 'package:kaiteki/utils/text/text_renderer.dart';

class SocialTextParser implements TextParser {
  static final _mentionPattern = RegExp(r'\B\@([\w\-]+)(?:\@([\w\-\.]+))?');
  static final _hashtagPattern = RegExp(r'#([a-zA-Z0-9_]+)');
  static final _urlPattern = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()!@:%_\+.~#?&\/\/=]*)');

  @override
  List<Element> parse(String text, [List<Element>? children]) {
    List<Element> elements = [TextElement(text)];

    regex(elements, _urlPattern, (match, _) {
      final url = match.group(0)!;
      return LinkElement(Uri.parse(url), children: [TextElement(url)]);
    });

    regex(elements, _mentionPattern, (match, _) {
      final reference = UserReference.handle(match.group(1)!, match.group(2));
      return MentionElement(reference);
    });

    regex(elements, _hashtagPattern, (match, _) {
      final hashtag = match.group(1)!;
      return HashtagElement(hashtag);
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
