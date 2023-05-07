import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kaiteki/fediverse/model/emoji/emoji.dart";
import "package:kaiteki/fediverse/model/emoji/lists/activities.g.dart";
import "package:kaiteki/fediverse/model/emoji/lists/animals_nature.g.dart";
import "package:kaiteki/fediverse/model/emoji/lists/flags.g.dart";
import "package:kaiteki/fediverse/model/emoji/lists/food_drink.g.dart";
import "package:kaiteki/fediverse/model/emoji/lists/objects.g.dart";
import "package:kaiteki/fediverse/model/emoji/lists/people_body.g.dart";
import "package:kaiteki/fediverse/model/emoji/lists/smileys_emotion.g.dart";
import "package:kaiteki/fediverse/model/emoji/lists/symbols.g.dart";
import "package:kaiteki/fediverse/model/emoji/lists/travel_places.g.dart";

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

class UnicodeEmojiCategory implements EmojiCategory {
  @override
  final String name;

  final UnicodeEmojiGroup type;

  @override
  List<Emoji> get emojis => items.map((e) => e.emoji).toList(growable: false);

  @override
  List<EmojiCategoryItem<UnicodeEmoji>> get items {
    return switch (type) {
      UnicodeEmojiGroup.activities => activities,
      UnicodeEmojiGroup.animalsNature => animalsNature,
      UnicodeEmojiGroup.flags => flags,
      UnicodeEmojiGroup.foodDrink => foodDrink,
      UnicodeEmojiGroup.objects => objects,
      UnicodeEmojiGroup.peopleBody => peopleBody,
      UnicodeEmojiGroup.smileysEmotion => smileysEmotion,
      UnicodeEmojiGroup.symbols => symbols,
      UnicodeEmojiGroup.travelPlaces => travelPlaces
    };
  }

  const UnicodeEmojiCategory(this.name, this.type);
}

enum UnicodeEmojiGroup {
  smileysEmotion,
  peopleBody,
  animalsNature,
  foodDrink,
  travelPlaces,
  activities,
  objects,
  symbols,
  flags;

  String getDisplayName(AppLocalizations l10n) {
    return switch (this) {
      UnicodeEmojiGroup.smileysEmotion => l10n.emojiUnicodeGroupSmileysEmotion,
      UnicodeEmojiGroup.peopleBody => l10n.emojiUnicodeGroupPeopleBody,
      UnicodeEmojiGroup.animalsNature => l10n.emojiUnicodeGroupAnimalsNature,
      UnicodeEmojiGroup.foodDrink => l10n.emojiUnicodeGroupFoodDrink,
      UnicodeEmojiGroup.travelPlaces => l10n.emojiUnicodeGroupTravelPlaces,
      UnicodeEmojiGroup.activities => l10n.emojiUnicodeGroupActivities,
      UnicodeEmojiGroup.objects => l10n.emojiUnicodeGroupObjects,
      UnicodeEmojiGroup.symbols => l10n.emojiUnicodeGroupSymbols,
      UnicodeEmojiGroup.flags => l10n.emojiUnicodeGroupFlags
    };
  }
}
