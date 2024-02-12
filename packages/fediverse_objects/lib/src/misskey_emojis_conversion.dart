import 'misskey/emoji.dart';

Object? misskeyEmojisReadValue(Map map, String key) {
  final value = map[key];

  if (value is Map) {
    return [
      for (final entry in value.entries)
        Emoji(
          name: entry.key,
          url: entry.value,
        ).toJson()
    ];
  }

  return value;
}
