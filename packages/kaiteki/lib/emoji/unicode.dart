import "package:kaiteki/generated/unicode_emoji.g.dart";
import "package:kaiteki_l10n/kaiteki_l10n.dart";
import "package:kaiteki_core/kaiteki_core.dart";

class UnicodeEmojiCategory implements EmojiCategory {
  @override
  final String name;

  final UnicodeEmojiGroup type;

  @override
  List<Emoji> get emojis => items.map((e) => e.emoji).toList(growable: false);

  @override
  List<EmojiCategoryItem<UnicodeEmoji>> get items {
    return switch (type) {
      UnicodeEmojiGroup.activities => activitiesEvents,
      UnicodeEmojiGroup.animalsNature => animalsNature,
      UnicodeEmojiGroup.flags => flags,
      UnicodeEmojiGroup.foodDrink => foodDrink,
      UnicodeEmojiGroup.objects => objects,
      UnicodeEmojiGroup.peopleBody => people,
      UnicodeEmojiGroup.smileysEmotion => smileysEmotions,
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
