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
    switch (type) {
      case UnicodeEmojiGroup.activities:
        return activities;
      case UnicodeEmojiGroup.animalsNature:
        return animalsNature;
      case UnicodeEmojiGroup.flags:
        return flags;
      case UnicodeEmojiGroup.foodDrink:
        return foodDrink;
      case UnicodeEmojiGroup.objects:
        return objects;
      case UnicodeEmojiGroup.peopleBody:
        return peopleBody;
      case UnicodeEmojiGroup.smileysEmotion:
        return smileysEmotion;
      case UnicodeEmojiGroup.symbols:
        return symbols;
      case UnicodeEmojiGroup.travelPlaces:
        return travelPlaces;
    }
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
    switch (this) {
      case UnicodeEmojiGroup.smileysEmotion:
        return l10n.emojiUnicodeGroupSmileysEmotion;
      case UnicodeEmojiGroup.peopleBody:
        return l10n.emojiUnicodeGroupPeopleBody;
      case UnicodeEmojiGroup.animalsNature:
        return l10n.emojiUnicodeGroupAnimalsNature;
      case UnicodeEmojiGroup.foodDrink:
        return l10n.emojiUnicodeGroupFoodDrink;
      case UnicodeEmojiGroup.travelPlaces:
        return l10n.emojiUnicodeGroupTravelPlaces;
      case UnicodeEmojiGroup.activities:
        return l10n.emojiUnicodeGroupActivities;
      case UnicodeEmojiGroup.objects:
        return l10n.emojiUnicodeGroupObjects;
      case UnicodeEmojiGroup.symbols:
        return l10n.emojiUnicodeGroupSymbols;
      case UnicodeEmojiGroup.flags:
        return l10n.emojiUnicodeGroupFlags;
    }
  }
}
