import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/custom_emoji_support.dart';
import 'package:kaiteki/fediverse/model/emoji/category.dart';
import 'package:kaiteki/fediverse/services/emoji.dart';
import 'package:kaiteki/ui/shared/common.dart';
import 'package:kaiteki/ui/shared/emoji/emoji_selector.dart';
import 'package:mdi/mdi.dart';

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
  List<UnicodeEmojiCategory>? _unicodeEmojis;

  _EmojiKindTab? _tabField;
  _EmojiKindTab? get _tab => _tabField;
  set _tab(_EmojiKindTab? tab) => setState(() => _tabField = tab);

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider)!;

    // "Basic" error checking whether tab can disappear between rebuilds
    final availableTabs = [
      if (widget.showCustomEmojis && account.adapter is CustomEmojiSupport)
        _EmojiKindTab.custom,
      if (widget.showUnicodeEmojis) _EmojiKindTab.unicode,
    ];

    final _EmojiKindTab tab;
    if (_tab == null || !availableTabs.contains(_tab)) {
      _tab = availableTabs.first;
    }
    tab = _tab!;

    final selectedButtonStyle = TextButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
    );

    final emojiTabSelectorAvailable =
        widget.showUnicodeEmojis && widget.showCustomEmojis;

    return Column(
      children: [
        ListTile(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Close',
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: widget.title ?? const Text('Select an emoji'),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        ),
        Expanded(child: _buildBody(context, tab)),
        if (emojiTabSelectorAvailable) ...[
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              runAlignment: WrapAlignment.center,
              spacing: 8.0,
              children: [
                if (availableTabs.contains(_EmojiKindTab.custom))
                  TextButton.icon(
                    label: const Text("Custom Emojis"),
                    icon: const Icon(Mdi.emoticon),
                    onPressed: () => _tab = _EmojiKindTab.custom,
                    style: _tab == _EmojiKindTab.custom
                        ? selectedButtonStyle
                        : null,
                  ),
                if (availableTabs.contains(_EmojiKindTab.unicode))
                  TextButton.icon(
                    label: const Text("Unicode Emojis"),
                    icon: const Icon(Mdi.unicode),
                    onPressed: () => _tab = _EmojiKindTab.unicode,
                    style: _tab == _EmojiKindTab.unicode
                        ? selectedButtonStyle
                        : null,
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  static List<UnicodeEmojiCategory> _getUnicodeCategories(
    BuildContext context,
  ) {
    final l10n = context.l10n;

    return UnicodeEmojiGroup.values
        .map(
          (g) => UnicodeEmojiCategory(
            g.getDisplayName(l10n),
            g,
          ),
        )
        .toList(growable: false);
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
        // FIXME(Craftplacer): Can't search unicode emojis because we don't have a list of aliases
        return _buildSelector(context, _unicodeEmojis!);
    }
  }
}

enum _EmojiKindTab { custom, unicode }
