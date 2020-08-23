import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kaiteki/api/model/mastodon/emoji.dart';
import 'package:kaiteki/utils/logger.dart';
import 'package:kaiteki/utils/tag.dart';
import 'package:kaiteki/utils/text_buffer.dart';
import 'package:kaiteki/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: It might be worth to make this into two parts
//       1. Being for breaking down the text, that being the TextParser.
//       2. Being for reading the results of the TextParser and mapping it to
//          different widgets.
class TextRenderer {
  Iterable<MastodonEmoji> emojis;

  TextStyle textStyle;
  TextStyle linkTextStyle;

  static const String emojiChar = ":";
  static const String tagStartChar = "<";
  static const String tagEndChar = ">";
  static const String linkTag = "a";
  static const String tagSeparator = " ";

  bool get _supportEmoji => emojis != null && emojis.length != 0;
  
  TextRenderer({this.emojis, this.textStyle, this.linkTextStyle});
  
  InlineSpan render(String text) {
    var spans = <InlineSpan>[];
    var buffer = TextBuffer();

    var tags = <Tag>[];

    var readingEmoji = false;
    var readingTag = false;
    var insideTag = tags.isNotEmpty;

    if (_supportEmoji) {
      Logger.debug("-----");
      Logger.debug("Starting to render text (${emojis.length}):");
      Logger.debug(text);
    }


    for (var i = 0; i < text.length; i++) {
      var char = text[i];

      switch (char) {
        case tagStartChar: {
          spans.add(plain(buffer));
          readingTag = true;
          break;
        }
        case tagEndChar: {
          var tag = Tag.parse(buffer.cut());

          // seems a bit shitty but tbh, how could this go wrong?
          if (tag.isClosing) {

            switch (tag.name.toLowerCase()) {
              case "br": {
                spans.add(TextSpan(text: "\n"));
                break;
              }

              case "a": {
                var openingTag = tags.removeLast();
                var label = buffer.cut();
                var location = openingTag.attributes["href"];

                spans.add(
                  TextSpan(
                    text: label,
                    style: linkTextStyle,
                    recognizer: TapGestureRecognizer()..onTap = () {
                      launch(location);
                    }
                  )
                );

                break;
              }

              default:
                tags.removeLast();
                break;
            }
          } else {
            tags.add(tag);
          }

          readingTag = false;
          break;
        }
        case emojiChar: {
          if (!_supportEmoji || readingTag)
            continue;


          if (readingEmoji) {
            var emojiName = buffer.text;

            var emojiFound = emojis.any((e) => Utils.compareCaseInsensitive(e.shortcode, emojiName));

            Logger.debug("$emojiName => $emojiFound");

            if (emojiFound) {
              var emoji = emojis.firstWhere((e) => Utils.compareCaseInsensitive(e.shortcode, emojiName));

              buffer.clear();

              // FIXME: fix it or I will make you not-cute >:(
              var emojiSpan = WidgetSpan(
                child: Image.network(
                  emoji.staticUrl,
                  width: 32,
                  height: 32,
                ),
              );

              spans.add(emojiSpan);

              readingEmoji = false;
            } else {
              // nothing found, so we restore the stolen colon and add a normal text span.
              buffer.prepend(emojiChar);
              spans.add(plain(buffer));
              readingEmoji = true;
            }
          } else {
            spans.add(plain(buffer));
            readingEmoji = true;
          }
          break;
        }

        default: {
          buffer.append(char);
          break;
        }
      }
    }

    if (buffer.text.isNotEmpty)
      spans.add(plain(buffer));

    return TextSpan(children: spans);
  }

  TextSpan plain(TextBuffer buffer) => TextSpan(
    style: textStyle,
    text: buffer.cut()
  );
}



