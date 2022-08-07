import 'dart:math' as math;

import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:collection/collection.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/emoji_category.dart';
import 'package:kaiteki/ui/shared/emoji/emoji_category_widget.dart';
import 'package:kaiteki/ui/shared/emoji/emoji_widget.dart';
import 'package:kaiteki/ui/shared/emoji/search_bar.dart';

class EmojiSelector extends StatefulWidget {
  final EmojiSelected onEmojiSelected;
  final Iterable<EmojiCategory> categories;

  const EmojiSelector({
    super.key,
    required this.categories,
    required this.onEmojiSelected,
  });

  @override
  State<EmojiSelector> createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late final AnchorScrollController _scrollController;
  late final int _emojiCount;
  final _searchTextController = TextEditingController();

  late Iterable<EmojiCategory> _categories;

  // /// Someone likes hoarding emojis
  // late final bool _insanelyLongEmojiList;

  @override
  void initState() {
    super.initState();

    _categories = widget.categories;

    _emojiCount = _categories //
        .map((category) => category.emojis.length)
        .sum;

    // _insanelyLongEmojiList = _emojiCount >= 1000;

    _searchTextController.addListener(() {
      _categories = applySearch(widget.categories);
      _updateTabController(_categories.length);
      setState(() {});
    });

    _updateTabController(_categories.length);

    _scrollController = AnchorScrollController(
      onIndexChanged: (i, _) => _tabController?.animateTo(i),
    );
  }

  @override
  void didUpdateWidget(covariant EmojiSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categories.length != oldWidget.categories.length) {
      _categories = applySearch(widget.categories);
      _updateTabController(_categories.length);
    }
  }

  void _updateTabController(int length) {
    _tabController?.dispose();
    _tabController = TabController(
      vsync: this,
      length: length,
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          key: ValueKey(_categories.length),
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.onSurface,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
          isScrollable: true,
          tabs: [
            for (var category in _categories)
              Tab(icon: _buildCategoryIcon(context, category)),
          ],
          controller: _tabController,
          onTap: (i) => _scrollController.scrollToIndex(
            index: i,
            scrollSpeed: math.log(_emojiCount),
          ),
        ),
        const Divider(height: 2),
        Expanded(
          child: Material(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SearchBar(controller: _searchTextController),
                  ),
                ),
                for (var i = 0; i < _categories.length; i++)
                  ..._buildCategorySlivers(_categories.elementAt(i), i),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCategorySlivers(EmojiCategory category, int index) {
    const emojiSize = 32.0;
    final widgets = <Widget>[
      if (category.name?.isNotEmpty == true)
        SliverToBoxAdapter(
          child: ListTile(
            title: Text(category.name!),
            enabled: false,
          ),
        ),
      SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 16 + emojiSize,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final emoji = category.emojis.elementAt(index);
            return IconButton(
              onPressed: () => widget.onEmojiSelected(emoji),
              icon: EmojiWidget(emoji: emoji, size: emojiSize),
              splashRadius: 24,
              tooltip: emoji.name,
            );
          },
          childCount: category.emojis.length,
        ),
      ),
    ];

    widgets[0] = AnchorItemWrapper(
      index: index,
      controller: _scrollController,
      child: widgets[0],
    );

    return widgets;
  }

  Widget _buildCategoryIcon(BuildContext context, EmojiCategory category) {
    if (category is UnicodeEmojiCategory) {
      return Icon(
        const {
              EmojiGroup.animalsNature: Icons.emoji_nature_rounded,
              EmojiGroup.symbols: Icons.emoji_symbols_rounded,
              EmojiGroup.flags: Icons.emoji_flags_rounded,
              EmojiGroup.smileysEmotion: Icons.emoji_emotions_rounded,
              EmojiGroup.objects: Icons.emoji_objects_rounded,
              EmojiGroup.travelPlaces: Icons.emoji_transportation_rounded,
              EmojiGroup.activities: Icons.emoji_events_rounded,
              EmojiGroup.foodDrink: Icons.emoji_food_beverage_rounded,
              EmojiGroup.peopleBody: Icons.emoji_people_rounded,
            }[category.emojiGroup] ??
            Icons.circle_rounded,
        size: 24,
      );
    }

    assert(category.emojis.isNotEmpty, "Cannot display empty emoji category");

    return EmojiWidget(
      emoji: category.emojis.elementAt(0),
      size: 24,
    );
  }

  Iterable<EmojiCategory> applySearch(Iterable<EmojiCategory> categories) {
    final query = _searchTextController.text;
    if (query.isEmpty) return categories;

    EmojiCategory _filterCategory(EmojiCategory category) {
      if (category is UnicodeEmojiCategory) {
        return UnicodeEmojiCategory(
          category.emojiGroup,
          filter: (emoji) => <String>[
            emoji.name,
            emoji.shortName,
            ...emoji.keywords,
          ].any((w) => w.contains(query)),
          skinTone: category.skinTone,
        );
      }

      return EmojiCategory(
        category.name,
        category.emojis.where(
          (emoji) => <String>[
            emoji.name,
            ...?emoji.aliases,
          ].any((w) => w.contains(query)),
        ),
      );
    }

    return categories
        .map(_filterCategory)
        .where((category) => category.emojis.isNotEmpty);
  }
}
