import "dart:math" as math;

import "package:anchor_scroll_controller/anchor_scroll_controller.dart";
import "package:collection/collection.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/emoji/unicode.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/ui/shared/emoji/emoji_button.dart";
import "package:kaiteki/ui/shared/emoji/emoji_widget.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki_core/model.dart";

const _emojiSize = 32.0;

class EmojiSelector extends ConsumerStatefulWidget {
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
  ConsumerState<EmojiSelector> createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends ConsumerState<EmojiSelector>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late final AnchorScrollController _scrollController;
  late final int _itemCount;
  final _searchTextController = TextEditingController();

  late Iterable<EmojiCategory> _categories;

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
    final color = Theme.of(context).useMaterial3
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.onSurfaceVariant;
    final hasEmojis = _categories.any((e) => e.items.isNotEmpty);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBar(
            controller: _searchTextController,
            // onSubmitted: (_) {
            //   final emoji = _categories.firstOrNull?.emojis.firstOrNull;
            //
            //   if (emoji != null) widget.onEmojiSelected(emoji);
            // },
            hintText: "Search for emojis",
            shadowColor: const MaterialStatePropertyAll(Colors.transparent),
          ),
        ),
        if (hasEmojis && _categories.length >= 2) ...[
          TabBar(
            key: ValueKey(_categories.length),
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: color,
            isScrollable: true,
            tabs: _categories
                .map((e) => Tab(icon: _buildCategoryIcon(context, e)))
                .toList(),
            controller: _tabController,
            onTap: (i) => _scrollController.scrollToIndex(
              index: i,
              scrollSpeed: math.log(_itemCount),
            ),
          ),
        ],
        Expanded(
          child: Material(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (!hasEmojis)
                  if (_searchTextController.text.isNotEmpty)
                    SliverFillRemaining(
                      child: IconLandingWidget(
                        icon: const Icon(Icons.search_off_rounded),
                        text: Text(context.l10n.searchEmojisNoResults),
                      ),
                    )
                  else
                    SliverFillRemaining(
                      child: IconLandingWidget(
                        icon: const Icon(Icons.sentiment_dissatisfied_rounded),
                        text: Text(context.l10n.noRecentlyUsedEmojis),
                      ),
                    )
                else
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
          addSemanticIndexes: false,
          addRepaintBoundaries: false,
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
      child: EmojiButton(
        item.emoji,
        size: _emojiSize,
        onTap: () => _onSelect(item.emoji),
        onLongTap: item.variants.isEmpty
            ? null
            : () async {
                final variant = await selectVariant(item);
                if (variant != null) _onSelect(variant);
              },
      ),
    );

    // HACK(Craftplacer): We disable displaying `Tooltip`s on slivers when debugging because that fails an assert when hot-reloading.
    if (!kDebugMode && tooltip != null) {
      child = Tooltip(message: tooltip, child: child);
    }

    return child;
  }

  void _onSelect(Emoji emoji) {
    widget.onEmojiSelected(emoji);
    addToRecents(emoji);
  }

  // TODO(Craftplacer): The recent emojis list is unbounded and will grow forever.
  void addToRecents(Emoji emoji) {
    final recents = ref.read(recentlyUsedEmojis).value;

    String toRecent(Emoji emoji) {
      if (emoji is UnicodeEmoji) return emoji.emoji;
      return emoji.tag;
    }

    final asString = toRecent(emoji);
    ref.read(recentlyUsedEmojis).value = [
      asString,
      ...recents.where((e) => e != asString),
    ];
  }

  Future<Emoji?> selectVariant(EmojiCategoryItem item) async {
    return showModalBottomSheet<Emoji?>(
      context: context,
      constraints: kBottomSheetConstraints,
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
  }

  String? _getTooltip(Emoji emoji) =>
      emoji is CustomEmoji ? ":${emoji.short}:" : null;

  Widget _buildCategoryIcon(BuildContext context, EmojiCategory category) {
    const iconMap = {
      UnicodeEmojiGroup.animalsNature: Icons.emoji_nature_rounded,
      UnicodeEmojiGroup.symbols: Icons.emoji_symbols_rounded,
      UnicodeEmojiGroup.flags: Icons.emoji_flags_rounded,
      UnicodeEmojiGroup.smileysEmotion: Icons.emoji_emotions_rounded,
      UnicodeEmojiGroup.objects: Icons.emoji_objects_rounded,
      UnicodeEmojiGroup.travelPlaces: Icons.emoji_transportation_rounded,
      UnicodeEmojiGroup.activities: Icons.emoji_events_rounded,
      UnicodeEmojiGroup.foodDrink: Icons.emoji_food_beverage_rounded,
      UnicodeEmojiGroup.peopleBody: Icons.emoji_people_rounded,
    };

    if (category is UnicodeEmojiCategory) {
      return Icon(
        iconMap[category.type] ?? Icons.circle_rounded,
        size: 24,
      );
    }

    assert(category.items.isNotEmpty, "Cannot display empty emoji category");

    return EmojiWidget(
      category.items[0].emoji,
      size: 24,
      square: true,
    );
  }

  Iterable<EmojiCategory> applySearch(List<EmojiCategory> categories) {
    final query = _searchTextController.text.toLowerCase();
    if (query.isEmpty) return categories;

    EmojiCategory filterCategory(EmojiCategory category) {
      return EmojiCategory.withVariants(
        category.name,
        category.items
            .where(
              (i) => i.emojis //
                  .expand(_getEmojiKeywords)
                  .map((e) => e.toLowerCase())
                  .any((w) => w.contains(query)),
            )
            .toList(growable: false),
      );
    }

    return categories
        .map(filterCategory)
        .where((category) => category.items.isNotEmpty);
  }

  List<String> _getEmojiKeywords(Emoji emoji) {
    return <String>[
      emoji.short,
      if (emoji.aliases != null)
        if (emoji is UnicodeEmoji)
          ...emoji.aliases.map((e) {
            return e.substring(1, e.length - 1).replaceAll("-", " ");
          })
        else
          ...?emoji.aliases,
    ];
  }
}

Iterable<Emoji> getRecentEmojis(WidgetRef ref, Iterable<Emoji> remoteEmojis) {
  final recentEmojis = ref.watch(recentlyUsedEmojis).value;
  return recentEmojis.map((e) {
    final split = e.split("@");
    final emoji = split[0];

    if (split.length != 2) return UnicodeEmoji(emoji);

    return remoteEmojis.firstWhereOrNull((e) => e.short == emoji);
  }).whereNotNull();
}
