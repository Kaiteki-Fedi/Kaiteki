import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/fediverse/model/emoji_category.dart';
import 'package:kaiteki/ui/widgets/emoji/emoji_widget.dart';

typedef EmojiSelected = void Function(Emoji emoji);

/// A widget that displays a grid of emojis from an emoji category.
class EmojiCategoryWidget extends StatelessWidget {
  final EmojiCategory category;
  final EmojiSelected onEmojiSelected;
  final double emojiSize;

  const EmojiCategoryWidget({
    Key? key,
    required this.category,
    required this.onEmojiSelected,
    this.emojiSize = 48,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Removed header bar for now, to make space.
        // Padding(
        //   padding: const EdgeInsets.only(right: 8.0),
        //   child: Row(
        //     children: [
        //       Expanded(child: SeparatorText(category.name)),
        //       Spacer(),
        //       IconButton(
        //         icon: Icon(Mdi.pencilPlus),
        //         onPressed: onInsertPack,
        //         tooltip: "Insert entire pack",
        //       ),
        //     ],
        //   ),
        // ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
              itemCount: category.emojis.length,
              itemBuilder: (context, i) {
                final emoji = category.emojis.elementAt(i);
                final tooltip = getTooltip(emoji);
                final child = IconButton(
                  icon: EmojiWidget(emoji: emoji, size: emojiSize),
                  onPressed: () => onEmojiSelected.call(emoji),
                  splashRadius: emojiSize * 0.75,
                  iconSize: emojiSize,
                );

                if (tooltip != null) {
                  return Tooltip(
                    message: tooltip,
                    child: child,
                  );
                }

                return child;
              },
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: emojiSize + 24,
              ),
            ),
          ),
        )
      ],
    );
  }

  // This method exists because how inconsistent Tooltips can be. One fill the
  // entire tap-able area, some don't. Besides that, it makes no sense to show
  // tooltips on Unicode emoji.
  String? getTooltip(Emoji emoji) {
    if (emoji is CustomEmoji) return emoji.toString();

    return null;
  }

  void onInsertPack() {
    for (final emoji in category.emojis) {
      onEmojiSelected.call(emoji);
    }
  }
}
