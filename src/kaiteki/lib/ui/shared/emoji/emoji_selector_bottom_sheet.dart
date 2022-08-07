import 'dart:async';

import 'package:emojis/emoji.dart' as unicode_emoji;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/interfaces/custom_emoji_support.dart';
import 'package:kaiteki/fediverse/model/emoji_category.dart';
import 'package:kaiteki/ui/shared/emoji/emoji_selector.dart';
import 'package:kaiteki/ui/shared/enum_icon_button.dart';
import 'package:kaiteki/ui/shared/toggle_icon_button.dart';
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
  var skinColor = unicode_emoji.fitzpatrick.None;

  late Future<List<UnicodeEmojiCategory>> _unicodeEmojis;
  Future<Iterable<EmojiCategory>>? _customEmojis;

  _EmojiKindTab? _tabField;
  _EmojiKindTab get _tab {
    return _tabField ??
        (widget.showCustomEmojis
            ? _EmojiKindTab.custom
            : _EmojiKindTab.unicode);
  }

  set _tab(_EmojiKindTab tab) {
    setState(() => _tabField = tab);
  }

  @override
  void initState() {
    super.initState();

    if (widget.showUnicodeEmojis) {
      _unicodeEmojis = compute(_getUnicodeCategories, null);
    }

    if (widget.showCustomEmojis) {
      final adapter = ref.read(adapterProvider) as CustomEmojiSupport;
      _customEmojis ??= adapter.getEmojis();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<FediverseAdapter>(
      adapterProvider,
      (_, adapter) {
        setState(() {
          if (adapter is CustomEmojiSupport) {
            _customEmojis = (adapter as CustomEmojiSupport).getEmojis();
          }
        });
      },
    );

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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              EnumIconButton<unicode_emoji.fitzpatrick>(
                tooltip: "Change skin color",
                iconBuilder: (context, _) => const SizedBox(),
                textBuilder: (context, v) => Text(v.name),
                value: skinColor,
                onChanged: (v) => setState(() => skinColor = v),
                values: unicode_emoji.fitzpatrick.values,
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<Iterable<EmojiCategory>>(
            future:
                _tab == _EmojiKindTab.unicode ? _unicodeEmojis : _customEmojis,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                final l10n = context.getL10n();
                return Center(child: Text(l10n.emojiRetrievalFailed));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return _buildSelector(context, snapshot.data!);
            },
          ),
        ),
        const Divider(height: 1),
        if (widget.showUnicodeEmojis && widget.showCustomEmojis)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleIconButton(
                tooltip: "Custom Emojis",
                icon: const Icon(Mdi.emoticon),
                onPressed: () => _tab = _EmojiKindTab.custom,
                selected: _tab == _EmojiKindTab.custom,
              ),
              ToggleIconButton(
                tooltip: "Unicode Emojis",
                icon: const Icon(Mdi.unicode),
                onPressed: () => _tab = _EmojiKindTab.unicode,
                selected: _tab == _EmojiKindTab.unicode,
              ),
            ],
          ),
      ],
    );
  }

  static FutureOr<List<UnicodeEmojiCategory>> _getUnicodeCategories(void a) {
    return unicode_emoji.EmojiGroup.values
        .where((g) => g != unicode_emoji.EmojiGroup.component)
        .map(UnicodeEmojiCategory.new)
        .toList(growable: false);
  }

  Widget _buildSelector(
    BuildContext context,
    Iterable<EmojiCategory> categories,
  ) {
    return EmojiSelector(
      categories: categories,
      onEmojiSelected: (emoji) => Navigator.of(context).pop(emoji),
    );
  }
}

enum _EmojiKindTab { custom, unicode }
