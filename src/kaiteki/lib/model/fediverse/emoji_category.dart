import 'package:kaiteki/model/fediverse/emoji.dart';

class EmojiCategory {
  final Iterable<Emoji> emojis;

  final String name;

  const EmojiCategory(this.name, this.emojis);
}
