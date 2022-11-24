import 'dart:math' as math;

import 'package:anchor_scroll_controller/anchor_scroll_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/fediverse/model/emoji/category.dart';
import 'package:kaiteki/fediverse/model/emoji/emoji.dart';
import 'package:kaiteki/ui/shared/emoji/emoji_button.dart';
import 'package:kaiteki/ui/shared/emoji/emoji_widget.dart';
import 'package:kaiteki/ui/shared/emoji/search_bar.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';

const _emojiSize = 32.0;

class EmojiSelector extends StatefulWidget {
  final Function(Emoji emoji) onEmojiSelected;
  final List<EmojiCategory> categories;
  final bool showSearch;

  const EmojiSelector({
    super.key,
    required this.categories,
    required this.onEmojiSelected,
    this.showSearch = true,
  });

  @override
  State<EmojiSelector> createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late final AnchorScrollController _scrollController;
  late final int _itemCount;
  final _searchTextController = TextEditingController();

  late List<EmojiCategory> _categories;

  @override
  void initState() {
    super.initState();

    _categories = widget.categories;

    _itemCount = _categories //
        .map((category) => category.items.length)
        .sum;

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
    _tabController = TabController(vsync: this, length: length);
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
            scrollSpeed: math.log(_itemCount),
          ),
        ),
        const Divider(height: 2),
        Expanded(
          child: Material(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (widget.showSearch)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SearchBar(controller: _searchTextController),
                    ),
                  ),
                if (_categories.isEmpty &&
                    _searchTextController.text.isNotEmpty)
                  const SliverFillRemaining(
                    child: IconLandingWidget(
                      icon: Icon(Icons.search_off_rounded),
                      // TODO(Craftplacer): Unlocalized string
                      text: Text("No emojis found"),
                    ),
                  )
                else
                  for (var i = 0; i < _categories.length; i++)
                    ..._buildCategorySlivers(_categories[i], i),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCategorySlivers(EmojiCategory category, int index) {
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
          maxCrossAxisExtent: 16 + _emojiSize,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildItem(context, category.items, index),
          childCount: category.items.length,
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

  Widget _buildItem(
    BuildContext context,
    List<EmojiCategoryItem> items,
    int index,
  ) {
    final item = items[index];
    final tooltip = _getTooltip(item.emoji);
    Widget child = GestureDetector(
      onLongPress: () async {
        if (item.variants.isEmpty) return;
        final variant = await showModalBottomSheet<Emoji?>(
          context: context,
          constraints: bottomSheetConstraints,
          builder: (context) {
            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
              ),
              itemCount: item.variants.length,
              itemBuilder: (context, index) {
                final variant = item.variants[index];
                return EmojiButton(
                  variant,
                  size: _emojiSize * 2,
                  onTap: () => Navigator.of(context).pop(variant),
                );
              },
            );
          },
        );
        if (variant != null) widget.onEmojiSelected(variant);
      },
      child: EmojiButton(
        item.emoji,
        size: _emojiSize,
        onTap: () => widget.onEmojiSelected(item.emoji),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip,
        child: child,
      );
    }

    if (item.variants.isNotEmpty) {
      child = Stack(
        children: [
          Positioned(
            bottom: -8,
            right: 0,
            child: Icon(
              Icons.more_horiz,
              color: Theme.of(context).disabledColor,
            ),
          ),
          Positioned.fill(child: child),
        ],
      );
    }

    return child;
  }

  String? _getTooltip(Emoji emoji) =>
      emoji is CustomEmoji ? ":${emoji.short}:" : null;

  Widget _buildCategoryIcon(BuildContext context, EmojiCategory category) {
    if (category is UnicodeEmojiCategory) {
      return Icon(
        const {
              UnicodeEmojiGroup.animalsNature: Icons.emoji_nature_rounded,
              UnicodeEmojiGroup.symbols: Icons.emoji_symbols_rounded,
              UnicodeEmojiGroup.flags: Icons.emoji_flags_rounded,
              UnicodeEmojiGroup.smileysEmotion: Icons.emoji_emotions_rounded,
              UnicodeEmojiGroup.objects: Icons.emoji_objects_rounded,
              UnicodeEmojiGroup.travelPlaces:
                  Icons.emoji_transportation_rounded,
              UnicodeEmojiGroup.activities: Icons.emoji_events_rounded,
              UnicodeEmojiGroup.foodDrink: Icons.emoji_food_beverage_rounded,
              UnicodeEmojiGroup.peopleBody: Icons.emoji_people_rounded,
            }[category.type] ??
            Icons.circle_rounded,
        size: 24,
      );
    }

    assert(category.items.isNotEmpty, "Cannot display empty emoji category");

    return EmojiWidget(
      emoji: category.items[0].emoji,
      size: 24,
    );
  }

  List<EmojiCategory> applySearch(List<EmojiCategory> categories) {
    final query = _searchTextController.text;
    if (query.isEmpty) return categories;

    EmojiCategory filterCategory(EmojiCategory category) {
      return EmojiCategory(
        category.name,
        category.items.where(
          (i) {
            final keywords = i.emojis.expand(
              (i) => <String>[
                i.short,
                ...?i.aliases,
              ],
            );
            return keywords.any((w) => w.contains(query));
          },
        ).toList(growable: false),
      );
    }

    return categories
        .map(filterCategory)
        .where((category) => category.items.isNotEmpty)
        .toList(growable: false);
  }
}
