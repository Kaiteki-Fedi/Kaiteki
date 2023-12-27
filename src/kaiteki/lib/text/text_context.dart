import "package:kaiteki_core/model.dart";

typedef EmojiResolver = Emoji? Function(String name);

class TextContext {
  final List<UserReference> users;
  final List<UserReference> excludedUsers;
  final EmojiResolver? emojiResolver;

  const TextContext({
    this.users = const [],
    this.emojiResolver,
    this.excludedUsers = const [],
  });
}
