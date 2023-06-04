import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/l10n/localizations.dart";
import "package:kaiteki/ui/main/tab_kind.dart";
import "package:kaiteki/ui/main/views/bird.dart";
import "package:kaiteki/ui/main/views/cat/view.dart";
import "package:kaiteki/ui/main/views/catalog.dart";
import "package:kaiteki/ui/main/views/deck.dart";
import "package:kaiteki/ui/main/views/fox.dart";
import "package:kaiteki/ui/main/views/kaiteki.dart";
import "package:kaiteki/ui/main/views/videos.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";

export "package:kaiteki/ui/main/tab_kind.dart";

typedef ViewConstructor<T extends MainScreenView> = T Function({
  required Widget Function(TabKind tab) getPage,
  required Function(TabKind tab) onChangeTab,
  required TabKind tab,
  required Function([MainScreenViewType? view]) onChangeView,
});

abstract class MainScreenView extends Widget {
  const MainScreenView({
    super.key,
    required Widget Function(TabKind tab) getPage,
    required Function(TabKind tab) onChangeTab,
    required TabKind tab,
    required Function(MainScreenViewType view) onChangeView,
  });
}

extension MainScreenViewExtension on MainScreenView {
  MainScreenViewType get type {
    return MainScreenViewType.values.firstWhere((e) => e.type == runtimeType);
  }
}

VoidCallback? getSearchCallback(BuildContext context, WidgetRef ref) {
  if (ref.watch(adapterProvider) is! SearchSupport) return null;
  return () {
    context.pushNamed("search", pathParameters: ref.accountRouterParams);
  };
}

enum MainScreenViewType<T extends MainScreenView> {
  stream(KaitekiMainScreenView.new),
  deck(DeckMainScreenView.new),
  catalog(CatalogMainScreenView.new),
  videos(VideoMainScreenView.new),
  fox(FoxMainScreenView.new),
  cat(CatMainScreenView.new),
  bird(BirdMainScreenView.new);

  Type get type => T;
  final ViewConstructor<T> create;

  const MainScreenViewType(this.create);

  Widget getIcon() {
    Widget buildFunnyEmojiIcon(String emoji) {
      return Builder(
        builder: (context) => SizedBox.square(
          dimension: 24,
          child: Text(
            emoji,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: IconTheme.of(context).size! * 0.8),
          ),
        ),
      );
    }

    return switch (this) {
      MainScreenViewType.stream => const Icon(Icons.view_stream_rounded),
      MainScreenViewType.deck => const Icon(Icons.view_column_rounded),
      MainScreenViewType.catalog => const Icon(Icons.view_module_rounded),
      MainScreenViewType.videos => const Icon(Icons.videocam_rounded),
      MainScreenViewType.fox => buildFunnyEmojiIcon("🦊"),
      MainScreenViewType.cat => buildFunnyEmojiIcon("🐱"),
      MainScreenViewType.bird => buildFunnyEmojiIcon("🐦"),
    };
  }

  String getDisplayName(KaitekiLocalizations l10n) {
    return switch (this) {
      MainScreenViewType.stream => "Stream",
      MainScreenViewType.deck => "Deck",
      MainScreenViewType.catalog => "Catalog",
      MainScreenViewType.videos => "Videos",
      MainScreenViewType.fox => "Fox",
      MainScreenViewType.cat => "Cat",
      MainScreenViewType.bird => "Bird",
    };
  }
}
