import 'package:kaiteki/fediverse/model/emoji.dart';

class EmojiCategory {
  final Iterable<Emoji> emojis;

  final String? name;

  const EmojiCategory(this.name, this.emojis);
}
