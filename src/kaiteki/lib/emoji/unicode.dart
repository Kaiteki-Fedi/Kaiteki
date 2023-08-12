import "package:kaiteki/l10n/localizations.dart";

import "package:kaiteki_core/kaiteki_core.dart";

import "lists/activities.g.dart";
import "lists/animals_nature.g.dart";
import "lists/flags.g.dart";
import "lists/food_drink.g.dart";
import "lists/objects.g.dart";
import "lists/people_body.g.dart";
import "lists/smileys_emotion.g.dart";
import "lists/symbols.g.dart";
import "lists/travel_places.g.dart";

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

  String getDisplayName(KaitekiLocalizations l10n) {
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
