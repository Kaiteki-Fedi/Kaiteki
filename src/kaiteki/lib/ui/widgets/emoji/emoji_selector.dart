import 'package:flutter/material.dart';
import 'package:kaiteki/model/fediverse/emoji_category.dart';
import 'package:kaiteki/ui/widgets/emoji/emoji_category_widget.dart';
import 'package:kaiteki/ui/widgets/emoji/emoji_widget.dart';
import 'package:mdi/mdi.dart';

class EmojiSelector extends StatefulWidget {
  final EmojiSelected onEmojiSelected;

  static const double emojiSize = 32;

  final Iterable<EmojiCategory> categories;

  const EmojiSelector({
    Key key,
    this.categories,
    this.onEmojiSelected,
  }) : super(key: key);

  @override
  _EmojiSelectorState createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  Map<int, GlobalKey> _itemKeys = <int, GlobalKey>{};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _tabController = TabController(
      vsync: this,
      length: widget.categories.length,
    );

    _tabController.addListener(() {
      var key = _itemKeys[_tabController.index];
      RenderBox box = key.currentContext.findRenderObject();
      var offset = box.localToGlobal(Offset.zero);

      var animationHeight = _scrollController.offset + offset.dy - 56.0;
      _scrollController.animateTo(
        animationHeight,
        duration: Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 4,
          child: Row(
            children: [
              Flexible(
                child: TabBar(
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
              VerticalDivider(),
              TextButton(
                child: Icon(Mdi.dotsVertical),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size.square(52)),
                ),
              ),
              TextButton(
                child: Icon(Mdi.close),
                onPressed: () => Navigator.of(context).pop(),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size.square(52)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              for (var category in widget.categories)
                EmojiCategoryWidget(
                  category: category,
                  emojiSize: EmojiSelector.emojiSize,
                  onEmojiSelected: widget.onEmojiSelected,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
