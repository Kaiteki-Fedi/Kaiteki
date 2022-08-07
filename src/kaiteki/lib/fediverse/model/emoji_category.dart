import 'package:emojis/emoji.dart' as unicode_emoji;
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:supercharged/supercharged.dart';

class EmojiCategory {
  final Iterable<Emoji> emojis;

  final String? name;

  const EmojiCategory(this.name, this.emojis);
}

class UnicodeEmojiCategory implements EmojiCategory {
  final unicode_emoji.EmojiGroup emojiGroup;
  final unicode_emoji.fitzpatrick skinTone;
  final bool Function(unicode_emoji.Emoji emoji)? filter;

  bool get isFiltered => filter != null;

  const UnicodeEmojiCategory(
    this.emojiGroup, {
    this.filter,
    this.skinTone = unicode_emoji.fitzpatrick.None,
  });

  @override
  Iterable<Emoji> get emojis {
    return unicode_emoji.Emoji.byGroup(emojiGroup)
        .where(filter ?? (_) => true)
        .groupBy(
          (e) {
            try {
              return e.newSkin(skinTone);
            } catch (_) {
              return e;
            }
          },
        )
        .keys
        .map(UnicodeEmoji.fromEmoji);
  }

  @override
  String get name => emojiGroup.name;
}
