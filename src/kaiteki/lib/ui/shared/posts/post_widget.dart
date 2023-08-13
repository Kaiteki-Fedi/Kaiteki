import "package:flutter/material.dart";
import "package:flutter/semantics.dart";
import "package:fpdart/fpdart.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/kaiteki/colors.dart";
import "package:kaiteki/ui/debug/text_render_dialog.dart";
import "package:kaiteki/ui/features/article_view/screen.dart";
import "package:kaiteki/ui/instance_vetting/bottom_sheet.dart";
import "package:kaiteki/ui/share_sheet/share.dart";
import "package:kaiteki/ui/shared/emoji/emoji_selector_bottom_sheet.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/posts/layouts/expanded.dart";
import "package:kaiteki/ui/shared/posts/layouts/layout.dart";
import "package:kaiteki/ui/shared/posts/layouts/normal.dart";
import "package:kaiteki/ui/shared/posts/layouts/wide.dart";
import "package:kaiteki/ui/shortcuts/activators.dart";
import "package:kaiteki/ui/shortcuts/intents.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:logging/logging.dart";
import "package:url_launcher/url_launcher.dart";

const kArticleViewThreshold = 300;
const kPostPadding = EdgeInsets.symmetric(vertical: 4.0);

const spacer = SizedBox(height: 8);

final sensitiveWords = {"cw", "mh", "ph", "pol", "suicide", "selfharm", "nsfw"};

final userThemeProvider =
    FutureProvider.family<({ColorScheme light, ColorScheme dark})?, String>(
  (ref, userId) async {
    final adapter = ref.watch(adapterProvider);
    final user = await adapter.getUserById(userId);

    if (user == null) return null;

    final url = user.bannerUrl ?? user.avatarUrl;

    if (url == null) return null;

    final imageProvider = NetworkImage(url.toString());
    return (
      light: await ColorScheme.fromImageProvider(provider: imageProvider),
      dark: await ColorScheme.fromImageProvider(
        provider: imageProvider,
        brightness: Brightness.dark,
      ),
    );
  },
  dependencies: [adapterProvider],
);

class PostWidget extends ConsumerStatefulWidget {
  static final _logger = Logger("PostWidget");

  final Post post;
  final PostWidgetLayout layout;

  /// onTap callback for content text
  final VoidCallback? onTap;

  final VoidCallback? onOpen;

  const PostWidget(
    this.post, {
    super.key,
    this.layout = PostWidgetLayout.normal,
    this.onTap,
    this.onOpen,
  });

  @override
  ConsumerState<PostWidget> createState() => _PostWidgetState();
}

enum PostWidgetLayout { normal, wide, expanded }

class _PostWidgetState extends ConsumerState<PostWidget> {
  late Post _post;
  Post? _translatedPost;
  final _menuController = MenuController();
  late final FocusNode _menuButtonFocusNode;
  final _menuAnchorKey = GlobalKey();

  Map<Type, Action<Intent>> get _actions {
    return {
      ReplyIntent: CallbackAction(onInvoke: (_) => _onReply),
      FavoriteIntent: CallbackAction(onInvoke: (_) => _onFavorite()),
      RepeatIntent: CallbackAction(onInvoke: (_) => _onRepeat()),
      BookmarkIntent: CallbackAction(onInvoke: (_) => _onBookmark()),
      ReactIntent: CallbackAction(onInvoke: (_) => _onReact()),
      OpenMenuIntent: CallbackAction(
        onInvoke: (_) => _menuController.open(),
      ),
    };
  }

  VoidCallback? get _onTap {
    final showOpenButton = ref.watch(showDedicatedPostOpenButton).value;
    return widget.onTap ?? (showOpenButton ? null : widget.onOpen);
  }

  void _onShowFavoritees() {
    context.pushNamed(
      "postFavorites",
      pathParameters: {
        ...ref.accountRouterParams,
        "id": _post.id,
      },
    );
  }

  void _onShowRepeatees() {
    context.pushNamed(
      "postRepeats",
      pathParameters: {
        ...ref.accountRouterParams,
        "id": _post.id,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final adapter = ref.watch(adapterProvider);

    final callbacks = InteractionCallbacks(
      onReply:
          adapter.authenticated ? _onReply.toOption() : const Option.none(),
      onFavorite:
          adapter.authenticated ? _onFavorite.toOption() : const Option.none(),
      onRepeat:
          adapter.authenticated ? _onRepeat.toOption() : const Option.none(),
      onReact:
          adapter.authenticated ? _onReact.toOption() : const Option.none(),
      onShowFavoritees: _onShowFavoritees,
      onShowRepeatees: _onShowRepeatees,
      onShowMenu: _onShowMenu,
    );

    final child = switch (widget.layout) {
      PostWidgetLayout.normal => NormalPostLayout(
          _post,
          callbacks: callbacks,
          onReact: _onChangeReaction,
          menuFocusNode: _menuButtonFocusNode,
          onTap: _onTap,
          onOpen: widget.onOpen,
        ),
      PostWidgetLayout.wide => WidePostLayout(
          _post,
          callbacks: callbacks,
          onReact: _onChangeReaction,
          menuFocusNode: _menuButtonFocusNode,
          onTap: _onTap,
          onOpen: widget.onOpen,
        ),
      PostWidgetLayout.expanded => ExpandedPostLayout(
          _post,
          callbacks: callbacks,
          onReact: _onChangeReaction,
          menuFocusNode: _menuButtonFocusNode,
          onTap: _onTap,
          onOpen: widget.onOpen,
        ),
    };

    return FocusableActionDetector(
      shortcuts: const {
        reply: ReplyIntent(),
        repeat: RepeatIntent(),
        favorite: FavoriteIntent(),
        bookmark: BookmarkIntent(),
        // react: ReactIntent(),
        menu: OpenMenuIntent(),
      },
      actions: _actions,
      child: InkWell(
        onTap: _onTap,
        child: MenuAnchor(
          key: _menuAnchorKey,
          anchorTapClosesMenu: true,
          menuChildren: _buildMenuItems(context),
          controller: _menuController,
          childFocusNode: _menuButtonFocusNode,
          crossAxisUnconstrained: false,
          builder: (context, controller, _) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onSecondaryTapUp: (details) {
                controller.open(position: details.localPosition);
              },
              onTertiaryTapUp: widget.onOpen.nullTransform(
                (callback) => (_) => callback(),
              ),
              child: Semantics(
                customSemanticsActions: _getSemanticsActions(context, adapter),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }

  void _onShowMenu() {
    final anchor =
        _menuAnchorKey.currentContext!.findRenderObject() as RenderBox;

    final button =
        _menuButtonFocusNode.context!.findRenderObject() as RenderBox;

    final offset = button.localToGlobal(Offset.zero, ancestor: anchor);

    _menuController.open(position: offset);
  }

  @override
  void dispose() {
    _menuButtonFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _menuButtonFocusNode = FocusNode();
    _post = widget.post;
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    final adapter = ref.read(adapterProvider);

    MenuItemButton buildShareMenuItem(BuildContext context) {
      return MenuItemButton(
        leadingIcon: const Icon(Icons.share_rounded),
        onPressed: () => share(context, _post),
        child: Text(context.l10n.shareButtonLabel),
      );
    }

    MenuItemButton buildBookmarkMenuItem(BuildContext context) {
      final l10n = context.l10n;
      return MenuItemButton(
        onPressed: _onBookmark,
        leadingIcon: Icon(
          _post.state.bookmarked
              ? Icons.bookmark_rounded
              : Icons.bookmark_border_rounded,
          color: Theme.of(context).ktkColors?.bookmarkColor,
        ),
        child: Text(
          _post.state.bookmarked
              ? l10n.postRemoveFromBookmarks
              : l10n.postAddToBookmarks,
        ),
      );
    }

    MenuItemButton buildDebugTextRenderingMenuItem(BuildContext context) {
      return MenuItemButton(
        leadingIcon: const Icon(Icons.bug_report_rounded),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => TextRenderDialog(_post),
        ),
        child: const Text("Debug text rendering"),
      );
    }

    MenuItemButton buildTranslateMenuItem(BuildContext context) {
      final translationAvailable = _isTranslationAvailable(ref);
      if (_translatedPost != null) {
        return MenuItemButton(
          leadingIcon: const Icon(Icons.undo_rounded),
          onPressed: () => setState(() => _translatedPost = null),
          child: Text(context.l10n.undoTranslateButton),
        );
      }

      return MenuItemButton(
        onPressed: translationAvailable ? _onTranslate : null,
        leadingIcon: const Icon(Icons.translate_rounded),
        child: Text(context.l10n.translateButton),
      );
    }

    MenuItemButton buildVetInstanceMenuItem(BuildContext context) {
      return MenuItemButton(
        leadingIcon: const Icon(Icons.shield_rounded),
        onPressed: () async => showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          constraints: bottomSheetConstraints,
          showDragHandle: true,
          builder: (_) => InstanceVettingBottomSheet(
            instance: _post.author.host,
          ),
        ),
        child: const Text("Vet instance"),
      );
    }

    Widget buildOpenInMenuItem(BuildContext context) {
      final currentAccount = ref.read(currentAccountProvider);
      final federatedAccounts = ref.read(accountManagerProvider).accounts.where(
            (e) =>
                e != currentAccount && e.adapter is DecentralizedBackendAdapter,
          );

      final url = _post.externalUrl;

      // It's just nonsensical to show a submenu for 1 item
      if (federatedAccounts.length < 2) {
        return MenuItemButton(
          leadingIcon: const Icon(Icons.open_in_browser_rounded),
          onPressed: url == null
              ? null
              : () async =>
                  launchUrl(url, mode: LaunchMode.externalApplication),
          child: Text(context.l10n.openInBrowserLabel),
        );
      }

      if (url == null) {
        return const MenuItemButton(
          leadingIcon: Icon(Icons.open_in_new),
          child: Text("Open in..."),
        );
      }

      return SubmenuButton(
        leadingIcon: const Icon(Icons.open_in_new),
        menuChildren: [
          MenuItemButton(
            leadingIcon: const Icon(Icons.web_asset_rounded),
            onPressed: () async => launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            ),
            child: const Text("Browser"),
          ),
          for (final account in federatedAccounts)
            MenuItemButton(
              leadingIcon: AvatarWidget(account.user, size: 24),
              child: Text(account.user.handle.toString()),
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final router = GoRouter.of(context);

                final adapter = account.adapter;
                final post = await adapter.resolveUrl(url);
                if (post is! Post) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        "Couldn't find post on ${account.key.host}",
                      ),
                    ),
                  );
                  return;
                }

                router.pushNamed(
                  "post",
                  pathParameters: {
                    ...account.key.routerParams,
                    "id": post.id,
                  },
                );
              },
            )
        ],
        child: const Text("Open in..."),
      );
    }

    return [
      if (adapter is BookmarkSupport) buildBookmarkMenuItem(context),
      buildTranslateMenuItem(context),
      if (ref.watch(AppExperiment.articleView.provider)) ...[
        MenuItemButton(
          leadingIcon: const Icon(Icons.article_rounded),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ArticleViewScreen(post: _post),
              ),
            );
          },
          child: const Text("View as article"),
        ),
      ],
      if (ref.watch(AppExperiment.instanceVetting.provider))
        buildVetInstanceMenuItem(context),
      const Divider(),
      buildShareMenuItem(context),
      buildOpenInMenuItem(context),
      if (_post.content != null &&
          ref.watch(preferences.developerMode).value) ...[
        const Divider(),
        buildDebugTextRenderingMenuItem(context),
      ]
    ];
  }

  Map<CustomSemanticsAction, VoidCallback> _getSemanticsActions(
    BuildContext context,
    BackendAdapter adapter,
  ) {
    final replyAction =
        CustomSemanticsAction(label: context.l10n.replyButtonLabel);
    final favoriteAction =
        CustomSemanticsAction(label: context.l10n.favoriteButtonLabel);
    final repeatAction =
        CustomSemanticsAction(label: context.l10n.repeatButtonLabel);
    final bookmarkAction =
        CustomSemanticsAction(label: context.l10n.bookmarkButtonLabel);
    final reactAction =
        CustomSemanticsAction(label: context.l10n.reactButtonLabel);

    return {
      replyAction: _onReply,
      if (adapter is FavoriteSupport) favoriteAction: _onFavorite,
      repeatAction: _onRepeat,
      bookmarkAction: _onBookmark,
      reactAction: _onReact,
    };
  }

  bool _isTranslationAvailable(WidgetRef ref) {
    final translator = ref.read(translatorProvider);
    final langId = ref.read(languageIdentificatorProvider);
    final serviceAvailable = translator != null && langId != null;
    if (serviceAvailable) return true;

    return ref.read(adapterProvider) is PostTranslationSupport;
  }

  Future<void> _onBookmark() async {
    final adapter = ref.read(adapterProvider);
    final l10n = context.l10n;

    try {
      final f = adapter as BookmarkSupport;

      final PostState newState;
      if (_post.state.bookmarked) {
        await f.unbookmarkPost(_post.id);
        newState = _post.state.copyWith(bookmarked: false);
      } else {
        await f.bookmarkPost(_post.id);
        newState = _post.state.copyWith(bookmarked: true);
      }

      setState(() => _post = _post.copyWith(state: newState));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _post.state.bookmarked
                  ? l10n.postBookmarkAdded
                  : l10n.postBookmarkRemoved,
            ),
          ),
        );
      }
    } catch (e, s) {
      context.showErrorSnackbar(
        text: Text(l10n.postBookmarkFailed),
        error: (e, s),
      );
      PostWidget._logger.warning("Failed to bookmark post", e, s);
    }
  }

  Future<void> _onChangeReaction(Emoji emoji) async {
    final messenger = ScaffoldMessenger.of(context);
    final account = ref.read(currentAccountProvider)!;
    final adapter = account.adapter as ReactionSupport;

    try {
      final hasReacted = _post.reactions.any(
        (r) => r.includesMe && r.emoji == emoji,
      );

      final Post newPost;

      // TODO(Craftplacer): Make reaction methods return Post? and prefer server responses rather than client-side post mutations
      if (hasReacted) {
        await adapter.removeReaction(_post, emoji);
        newPost = _post.removeOrDeleteReaction(
          emoji,
          account.user,
        );
      } else {
        await adapter.addReaction(_post, emoji);
        newPost = _post.addOrCreateReaction(
          emoji,
          account.user,
          !adapter.capabilities.supportsMultipleReactions,
        );
      }

      setState(() => _post = newPost);
    } catch (e, s) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text("Failed to react to post"),
          action: SnackBarAction(
            label: "Show details",
            onPressed: () => context.showExceptionDialog((e, s)),
          ),
        ),
      );
      PostWidget._logger.warning("Failed to react to post", e, s);
    }
  }

  Future<void> _onFavorite() async {
    final adapter = ref.read(adapterProvider);
    final l10n = context.l10n;

    try {
      final f = adapter as FavoriteSupport;
      final PostState newState;

      if (_post.state.favorited) {
        await f.unfavoritePost(_post.id);
        newState = _post.state.copyWith(favorited: false);
      } else {
        await f.favoritePost(_post.id);
        newState = _post.state.copyWith(favorited: true);
      }

      setState(() => _post = _post.copyWith(state: newState));
    } catch (e, s) {
      context.showErrorSnackbar(
        text: Text(l10n.postFavoriteFailed),
        error: (e, s),
      );
      PostWidget._logger.warning("Failed to favorite post", e, s);
    }
  }

  Future<void> _onReact() async {
    final adapter = ref.read(adapterProvider) as ReactionSupport;
    final emoji = await showModalBottomSheet<Emoji?>(
      context: context,
      constraints: bottomSheetConstraints,
      builder: (_) => EmojiSelectorBottomSheet(
        showCustomEmojis: adapter.capabilities.supportsCustomEmojiReactions,
        showUnicodeEmojis: adapter.capabilities.supportsUnicodeEmojiReactions,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      elevation: 16.0,
      clipBehavior: Clip.antiAlias,
    );

    if (emoji == null) return;

    _onChangeReaction(emoji);
  }

  Future<void> _onRepeat() async {
    final adapter = ref.read(adapterProvider);
    final l10n = context.l10n;
    try {
      final PostState newState;

      if (_post.state.repeated) {
        await adapter.unrepeatPost(_post.id);
        newState = _post.state.copyWith(repeated: false);
      } else {
        await adapter.repeatPost(_post.id);
        newState = _post.state.copyWith(repeated: true);
      }

      setState(() => _post = _post.copyWith(state: newState));
    } catch (e, s) {
      context.showErrorSnackbar(
        text: Text(l10n.postRepeatFailed),
        error: (e, s),
      );
      PostWidget._logger.warning("Failed to repeat post", e, s);
    }
  }

  Future<void> _onReply() async {
    final router = GoRouter.of(context);
    // ignore: cascade_invocations
    router.pushNamed(
      "compose",
      pathParameters: ref.accountRouterParams,
      extra: _post,
    );
  }

  Future<void> _onTranslate() async {
    final content = _post.content;
    if (content == null) return;

    final adapter = ref.read(adapterProvider);
    if (adapter is PostTranslationSupport) {
      final displayLang = Localizations.localeOf(context).languageCode;
      final translationAdapter = adapter as PostTranslationSupport;

      final translatedPost = await translationAdapter.translatePost(
        _post,
        displayLang,
      );

      setState(() => _translatedPost = translatedPost);
      return;
    }

    final translator = ref.read(translatorProvider);
    final langId = ref.read(languageIdentificatorProvider);
    if (translator != null && langId != null) {
      final displayLang = Localizations.localeOf(context).languageCode;
      final sourceLang = await langId.identifyLanguage(content);

      if (sourceLang == null &&
          !translator.supportsLanguageDetection &&
          mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not determine source language."),
          ),
        );
        return;
      }

      final translatedContent = await translator.translate(
        _post.content!,
        displayLang,
        sourceLang,
      );

      setState(
        () => _translatedPost = _post.copyWith(
          content: translatedContent,
        ),
      );
      return;
    }
  }
}
