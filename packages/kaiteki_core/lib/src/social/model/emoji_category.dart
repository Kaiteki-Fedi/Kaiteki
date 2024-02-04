import 'emoji.dart';

class EmojiCategory {
  final List<EmojiCategoryItem> items;

  List<Emoji> get emojis => items.map((e) => e.emoji).toList(growable: false);

  final String? name;

  factory EmojiCategory(String? name, Iterable<Emoji> items) {
    return EmojiCategory.withVariants(
      name,
      items.map(EmojiCategoryItem.new).toList(growable: false),
    );
  }

  const EmojiCategory.withVariants(this.name, this.items);
}

class EmojiCategoryItem<T extends Emoji> {
  final T emoji;
  final List<T> variants;

  /// HACK(Craftplacer): looks a bit trash, I must tell you
  List<Emoji> get emojis => [emoji, ...variants];

  const EmojiCategoryItem(this.emoji, [this.variants = const []]);
}
