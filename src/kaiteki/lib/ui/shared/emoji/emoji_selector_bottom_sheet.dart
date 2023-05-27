import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/interfaces/custom_emoji_support.dart";
import "package:kaiteki/fediverse/model/emoji/category.dart";
import "package:kaiteki/fediverse/services/emoji.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/emoji/emoji_selector.dart";
import "package:mdi/mdi.dart";

class EmojiSelectorBottomSheet extends ConsumerStatefulWidget {
  final Widget? title;
  final bool showUnicodeEmojis;
  final bool showCustomEmojis;

  const EmojiSelectorBottomSheet({
    super.key,
    this.title,
    this.showUnicodeEmojis = true,
    this.showCustomEmojis = true,
  });

  @override
  ConsumerState<EmojiSelectorBottomSheet> createState() =>
      _EmojiSelectorBottomSheetState();
}

class _EmojiSelectorBottomSheetState
    extends ConsumerState<EmojiSelectorBottomSheet> {
  Iterable<UnicodeEmojiCategory>? _unicodeEmojis;

  _EmojiKindTab? _tabField;
  _EmojiKindTab? get _tab => _tabField;
  set _tab(_EmojiKindTab? tab) => setState(() => _tabField = tab);

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider)!;

    // "Basic" error checking whether tab can disappear between rebuilds
    final availableTabs = [
      _EmojiKindTab.recent,
      if (widget.showCustomEmojis && account.adapter is CustomEmojiSupport)
        _EmojiKindTab.custom,
      if (widget.showUnicodeEmojis) _EmojiKindTab.unicode,
    ];

    final _EmojiKindTab tab;
    if (_tab == null || !availableTabs.contains(_tab)) {
      _tab = availableTabs.first;
    }
    tab = _tab!;

    final emojiTabSelectorAvailable =
        widget.showUnicodeEmojis && widget.showCustomEmojis;

    return Column(
      children: [
        Expanded(child: _buildBody(context, tab)),
        if (emojiTabSelectorAvailable) ...[
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton(
              segments: [
                if (availableTabs.contains(_EmojiKindTab.recent))
                  const ButtonSegment(
                    value: _EmojiKindTab.recent,
                    label: Text("Recent"),
                    icon: Icon(Icons.history_rounded),
                  ),
                if (availableTabs.contains(_EmojiKindTab.custom))
                  const ButtonSegment(
                    value: _EmojiKindTab.custom,
                    label: Text("Custom"),
                    icon: Icon(Icons.insert_emoticon_rounded),
                  ),
                if (availableTabs.contains(_EmojiKindTab.unicode))
                  const ButtonSegment(
                    value: _EmojiKindTab.unicode,
                    label: Text("Unicode"),
                    icon: Icon(Mdi.unicode),
                  ),
              ],
              showSelectedIcon: false,
              selected: {_tab},
              onSelectionChanged: (v) => _tab = v.first,
            ),
          ),
        ],
      ],
    );
  }

  static Iterable<UnicodeEmojiCategory> _getUnicodeCategories(
    BuildContext context,
  ) {
    final l10n = context.l10n;

    return UnicodeEmojiGroup.values
        .map((g) => UnicodeEmojiCategory(g.getDisplayName(l10n), g));
  }

  Widget _buildSelector(
    BuildContext context,
    List<EmojiCategory> categories, [
    bool showSearch = true,
  ]) {
    return EmojiSelector(
      categories: categories,
      onEmojiSelected: (emoji) => Navigator.of(context).pop(emoji),
      showSearch: showSearch,
    );
  }

  Widget _buildBody(BuildContext context, _EmojiKindTab tab) {
    final l10n = context.l10n;

    switch (tab) {
      case _EmojiKindTab.recent:
        final account = ref.read(accountProvider)!;
        final customEmojis = emojiServiceProvider(account.key);

        return ref
            .watch(customEmojis) //
            .when(
              data: (emojis) {
                final flattened = emojis.map((e) => e.emojis).flattened;
                final recentEmojis = getRecentEmojis(ref, flattened);
                return _buildSelector(
                  context,
                  [EmojiCategory(null, recentEmojis)],
                );
              },
              // TODO(Craftplacer): Add ability to see error details for failure on fetching custom emojis
              error: (_, __) => Center(child: Text(l10n.emojiRetrievalFailed)),
              loading: () => centeredCircularProgressIndicator,
            );
      case _EmojiKindTab.custom:
        final account = ref.read(accountProvider)!;
        final customEmojis = emojiServiceProvider(account.key);
        return ref
            .watch(customEmojis) //
            .when(
              data: (emojis) => _buildSelector(context, emojis),
              // TODO(Craftplacer): Add ability to see error details for failure on fetching custom emojis
              error: (_, __) => Center(child: Text(l10n.emojiRetrievalFailed)),
              loading: () => centeredCircularProgressIndicator,
            );
      case _EmojiKindTab.unicode:
        _unicodeEmojis ??= _getUnicodeCategories(context);
        return _buildSelector(context, _unicodeEmojis!.toList(growable: false));
    }
  }
}

enum _EmojiKindTab { custom, unicode, recent }
