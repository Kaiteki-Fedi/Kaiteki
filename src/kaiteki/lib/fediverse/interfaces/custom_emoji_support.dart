import 'package:kaiteki/fediverse/model/emoji/category.dart';

abstract class CustomEmojiSupport {
  Future<List<EmojiCategory>> getEmojis();
}
