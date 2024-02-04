import 'package:build/build.dart';

import 'src/emoji_builder.dart';

Builder emojiBuilder(BuilderOptions options) {
  print(options.config['emoji_list_url']);
  var emojiListUrl = options.config['emoji_list_url'] as String?;
  emojiListUrl ??=
      "https://raw.githubusercontent.com/googlefonts/emoji-metadata/main/emoji_15_1_ordering.json";

  if (emojiListUrl == null) throw ArgumentError('emoji_list_url is required');

  return EmojiBuilder(
    emojiListUrl: Uri.parse(emojiListUrl),
  );
}
