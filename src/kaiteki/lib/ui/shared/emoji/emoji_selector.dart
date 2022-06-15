import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart' as consts;
import 'package:kaiteki/fediverse/model/emoji_category.dart';
import 'package:kaiteki/ui/shared/emoji/emoji_category_widget.dart';
import 'package:kaiteki/ui/shared/emoji/emoji_widget.dart';

class EmojiSelector extends StatefulWidget {
  final EmojiSelected onEmojiSelected;
  final Iterable<EmojiCategory> categories;

  const EmojiSelector({
    Key? key,
    required this.categories,
    required this.onEmojiSelected,
  }) : super(key: key);

  @override
  State<EmojiSelector> createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: widget.categories.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TabBar(
                indicatorColor: Theme.of(context).colorScheme.primary,
                isScrollable: true,
                tabs: [
                  for (var category in widget.categories)
                    Tab(
                      icon: EmojiWidget(
                        emoji: category.emojis.elementAt(0),
                        size: 24,
                      ),
                    ),
                ],
                controller: _tabController,
              ),
            ),
            const VerticalDivider(),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.of(context).pop(),
              splashRadius: consts.defaultSplashRadius,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
            ),
          ],
        ),
        const Divider(height: 2),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (var category in widget.categories)
                EmojiCategoryWidget(
                  category: category,
                  emojiSize: 32,
                  onEmojiSelected: widget.onEmojiSelected,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
