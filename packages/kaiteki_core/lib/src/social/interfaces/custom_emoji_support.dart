import 'package:kaiteki_core/model.dart';

abstract class CustomEmojiSupport {
  Future<List<EmojiCategory>> getEmojis();
}
