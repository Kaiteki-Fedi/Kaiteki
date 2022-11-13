import 'package:kaiteki/fediverse/model/emoji_category.dart';

abstract class CustomEmojiSupport {
  Future<Iterable<EmojiCategory>> getEmojis();
}
