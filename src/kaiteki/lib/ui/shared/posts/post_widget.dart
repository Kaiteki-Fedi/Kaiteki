import "package:flutter/material.dart";
import "package:flutter/semantics.dart";
import "package:fpdart/fpdart.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/bookmarks.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/colors.dart";
import "package:kaiteki/translation/language_identificator.dart";
import "package:kaiteki/translation/translator.dart";
import "package:kaiteki/ui/debug/text_render_dialog.dart";
import "package:kaiteki/ui/features/article_view/screen.dart";
import "package:kaiteki/ui/share_sheet/share.dart";
import "package:kaiteki/ui/shared/dialogs/content_not_public_dialog.dart";
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

import "post_widget_menu_items.dart";

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

  // I at first thought, "why not copy Flutter with their named constructors?"
  // but then I remembered, the mess that are the different Button widgets,
  // alongside their different constructors.
  // btw, this is a feature, not a bug: https://github.com/flutter/flutter/issues/125508
  final bool? useCard;

  const PostWidget(
    this.post, {
    super.key,
    this.layout = PostWidgetLayout.normal,
    this.onTap,
    this.onOpen,
    this.useCard,
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
  late final FocusNode _focusNode;
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

    final isAuthenticated = adapter.authenticated;
    final canFavorite = isAuthenticated && adapter is FavoriteSupport;
    final canReact = isAuthenticated && adapter is ReactionSupport;
    final callbacks = InteractionCallbacks(
      onReply: isAuthenticated ? Option.of(_onReply) : const Option.none(),
      onFavorite: canFavorite ? Option.of(_onFavorite) : const Option.none(),
      onRepeat: isAuthenticated ? Option.of(_onRepeat) : const Option.none(),
      onReact: canReact ? Option.of(_onReact) : const Option.none(),
      onShowFavoritees: _onShowFavoritees,
      onShowRepeatees: _onShowRepeatees,
      onShowMenu: _onShowMenu,
    );

    final body = switch (widget.layout) {
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

    Widget child = InkWell(
      onTap: _onTap,
      child: MenuAnchor(
        key: _menuAnchorKey,
        consumeOutsideTap: true,
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
            onTertiaryTapUp: widget.onOpen.andThen(
              (callback) => (_) => callback(),
            ),
            child: _PostFocusRing(focusNode: _focusNode, child: body),
          );
        },
      ),
    );

    final useCards =
        widget.useCard ?? PostWidgetTheme.of(context)?.useCards ?? true;
    if (useCards) child = Card(child: child);

    return FocusableActionDetector(
      descendantsAreTraversable: false,
      focusNode: _focusNode,
      shortcuts: const {
        reply: ReplyIntent(),
        repeat: RepeatIntent(),
        favorite: FavoriteIntent(),
        bookmark: BookmarkIntent(),
        // react: ReactIntent(),
        menu: OpenMenuIntent(),
      },
      actions: _actions,
      child: Semantics(
        customSemanticsActions: _getSemanticsActions(context, adapter),
        child: MergeSemantics(child: child),
      ),
    );
  }

  void _onShowMenu() {
    final anchor =
        _menuAnchorKey.currentContext!.findRenderObject() as RenderBox;

    final buttonContext = _menuButtonFocusNode.context;

    assert(buttonContext != null);

    final buttonRenderBox = buttonContext!.findRenderObject() as RenderBox;
    final offset = buttonRenderBox.localToGlobal(Offset.zero, ancestor: anchor);

    _menuController.open(position: offset);
  }

  @override
  void dispose() {
    _menuButtonFocusNode.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _menuButtonFocusNode = FocusNode();
    _post = widget.post;
  }

  @override
  void didUpdateWidget(covariant PostWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _post = widget.post;
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    final adapter = ref.read(adapterProvider);

    Widget buildOpenInMenuItem(BuildContext context) {
      final currentAccount = ref.read(currentAccountProvider);
      final federatedAccounts = ref.read(accountManagerProvider).accounts.where(
            (e) =>
                e != currentAccount && e.adapter is DecentralizedBackendAdapter,
          );

      final url = _post.externalUrl;

      // It's just nonsensical to show a submenu for 1 item
      if (federatedAccounts.length < 2) {
        return OpenInBrowserMenuItem(
          onPressed: url.andThen(
            (url) => () async =>
                launchUrl(url, mode: LaunchMode.externalApplication),
          ),
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
            onPressed: _openInBrowser,
            child: const Text("Browser"),
          ),
          for (final account in federatedAccounts)
            MenuItemButton(
              leadingIcon: AvatarWidget(account.user, size: 24),
              child: Text(account.user.handle.toString()),
              onPressed: () => _onOpenRemote(account),
            ),
        ],
        child: const Text("Open in..."),
      );
    }

    return [
      if (adapter is BookmarkSupport)
        BookmarkMenuItem(
          bookmarked: _post.state.bookmarked,
          onPressed: _onBookmark,
        ),
      if (_translatedPost == null)
        TranslateMenuItem(
          onPressed: _isTranslationAvailable(ref) ? _onTranslate : null,
        )
      else
        UndoTranslationMenuItem(
          onPressed: () => setState(() => _translatedPost = null),
        ),
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
      const Divider(),
      ShareMenuItem(onPressed: () => share(context, _post)),
      buildOpenInMenuItem(context),
      if (_post.content != null &&
          ref.watch(preferences.developerMode).value) ...[
        const Divider(),
        DebugTextRenderingMenuItem(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => TextRenderDialog(_post),
          ),
        ),
      ],
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
    const showOriginalAuthor =
        CustomSemanticsAction(label: "Open author's profile");

    return {
      replyAction: _onReply,
      if (adapter is FavoriteSupport) favoriteAction: _onFavorite,
      repeatAction: _onRepeat,
      bookmarkAction: _onBookmark,
      reactAction: _onReact,
      showOriginalAuthor: () {
        context.showUser(_post.author, ref);
      },
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
    final accountKey = ref.read(currentAccountProvider)!.key;
    final bookmarks = ref.read(bookmarksServiceProvider(accountKey).notifier);
    final l10n = context.l10n;

    try {
      final PostState newState;
      if (_post.state.bookmarked) {
        await bookmarks.remove(_post.id);
        newState = _post.state.copyWith(bookmarked: false);
      } else {
        await bookmarks.add(_post.id);
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

  Future<void> _translateViaBackend() async {
    final displayLang = Localizations.localeOf(context).languageCode;
    final translationAdapter = adapter as PostTranslationSupport;

    final translatedPost = await translationAdapter.translatePost(
      _post,
      displayLang,
    );

    setState(() => _translatedPost = translatedPost);
  }

  Future<void> _onOpenRemote(Account account) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    final adapter = account.adapter;
    final post = await adapter.resolveUrl(_post.externalUrl!);

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
  }

  Future<void> _translateViaExternalService(
    Translator translator,
    LanguageIdentificator languageId,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final displayLang = Localizations.localeOf(context).languageCode;
    final sourceLang = await languageId.identifyLanguage(_post.content!);

    if (sourceLang == null &&
        !translator.supportsLanguageDetection &&
        mounted) {
      scaffoldMessenger.showSnackBar(
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
  }

  Future<void> _onTranslate() async {
    final content = _post.content;
    if (content == null) return;

    final adapter = ref.read(adapterProvider);
    if (adapter is PostTranslationSupport) {
      await _translateViaBackend();
      return;
    }

    final translator = ref.read(translatorProvider);
    final languageId = ref.read(languageIdentificatorProvider);
    if (translator != null && languageId != null) {
      await _translateViaExternalService(translator, languageId);
      return;
    }
  }

  Future<void> _openInBrowser() async {
    final isPublic = _post.visibility == PostScope.public ||
        _post.visibility == PostScope.unlisted;
    if (!isPublic) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => const ContentNotPublicDialog(),
      );

      if (result != true) return;
    }

    await launchUrl(
      _post.externalUrl!,
      mode: LaunchMode.externalApplication,
    );
  }
}

class _PostFocusRing extends StatelessWidget {
  const _PostFocusRing({
    required this.focusNode,
    required this.child,
  });

  final FocusNode focusNode;
  final ConsumerWidget child;

  @override
  Widget build(BuildContext context) {
    final border = Border.all(
      strokeAlign: BorderSide.strokeAlignCenter,
      color: Theme.of(context).colorScheme.tertiary,
      width: 4,
    );

    return ListenableBuilder(
      listenable: focusNode,
      builder: (context, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: focusNode.hasPrimaryFocus ? border : null,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
