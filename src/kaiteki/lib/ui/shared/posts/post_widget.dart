import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/semantics.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/preferences/content_warning_behavior.dart";
import "package:kaiteki/theming/kaiteki/colors.dart";
import "package:kaiteki/ui/debug/text_render_dialog.dart";
import "package:kaiteki/ui/features/article_view/screen.dart";
import "package:kaiteki/ui/instance_vetting/bottom_sheet.dart";
import "package:kaiteki/ui/share_sheet/share.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/emoji/emoji_selector_bottom_sheet.dart";
import "package:kaiteki/ui/shared/posts/attachment_row.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/posts/embed_widget.dart";
import "package:kaiteki/ui/shared/posts/embedded_post.dart";
import "package:kaiteki/ui/shared/posts/interaction_bar.dart";
import "package:kaiteki/ui/shared/posts/interaction_event_bar.dart";
import "package:kaiteki/ui/shared/posts/meta_bar.dart";
import "package:kaiteki/ui/shared/posts/poll_widget.dart";
import "package:kaiteki/ui/shared/posts/post_metrics_bar.dart";
import "package:kaiteki/ui/shared/posts/reaction_row.dart";
import "package:kaiteki/ui/shared/posts/reply_bar.dart";
import "package:kaiteki/ui/shared/posts/subject_bar.dart";
import "package:kaiteki/ui/shortcuts/activators.dart";
import "package:kaiteki/ui/shortcuts/intents.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:url_launcher/url_launcher.dart";

const kPostPadding = EdgeInsets.symmetric(vertical: 4.0);
const kArticleViewThreshold = 300;

const spacer = SizedBox(height: 8);

final sensitiveWords = {"cw", "mh", "ph", "pol", "suicide", "selfharm", "nsfw"};

class PostWidget extends ConsumerStatefulWidget {
  final Post post;
  final bool showParentPost;
  final bool showActions;
  final bool showReplyee;
  final bool showAvatar;
  final bool? showTime;
  final bool? showVisibility;
  final PostWidgetLayout layout;

  /// onTap callback for content text
  final VoidCallback? onTap;

  final VoidCallback? onOpen;

  const PostWidget(
    this.post, {
    super.key,
    this.showParentPost = true,
    this.showActions = true,
    this.showReplyee = true,
    this.showAvatar = true,
    this.showVisibility,
    this.showTime,
    this.layout = PostWidgetLayout.normal,
    this.onTap,
    this.onOpen,
  });

  @override
  ConsumerState<PostWidget> createState() => _PostWidgetState();
}

enum PostWidgetLayout { normal, wide, expanded }

class _PostContent extends ConsumerStatefulWidget {
  final Post post;
  final bool showReplyee;
  final VoidCallback? onTap;
  final TextStyle? style;

  const _PostContent({
    required this.post,
    required this.showReplyee,
    this.onTap,
    // ignore: unused_element, this can't be removed you dumbfuck
    this.style,
  });

  @override
  ConsumerState<_PostContent> createState() => _PostContentWidgetState();
}

class _PostContentWidgetState extends ConsumerState<_PostContent> {
  InlineSpan? renderedContent;
  bool collapsed = false;

  bool get hasContent {
    return renderedContent != null &&
        renderedContent!.toPlainText().trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final subject = widget.post.subject;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subject != null && subject.isNotEmpty == true)
          SubjectBar(
            subject: post.subject!,
            collapsed: collapsed,
            onTap: () => setState(() => collapsed = !collapsed),
          ),
        if (hasContent && !collapsed)
          Padding(
            padding: kPostPadding,
            child: SelectableText.rich(
              TextSpan(children: [renderedContent!]),
              // FIXME(Craftplacer): https://github.com/flutter/flutter/issues/53797
              onTap: widget.onTap,
              style: widget.style,
            ),
          ),
        if (post.poll != null) ...[
          spacer,
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: PollWidget.fromPost(
              post,
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
        if (post.quotedPost != null) EmbeddedPostWidget(post.quotedPost!),
        if (post.attachments?.isNotEmpty == true) ...[
          spacer,
          AttachmentRow(post: post),
        ],
        if (post.embeds.isNotEmpty) ...[
          spacer,
          Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                for (var embed in post.embeds) EmbedWidget(embed),
              ].joinWithValue(const Divider(height: 1)),
            ),
          ),
        ],
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _renderContent();

    final cwBehavior = ref.watch(preferences.cwBehavior).value;

    final subject = widget.post.subject;
    final hasSubject = subject != null && subject.isNotEmpty;

    if (hasSubject) {
      switch (cwBehavior) {
        case ContentWarningBehavior.collapse:
          collapsed = true;
          break;
        case ContentWarningBehavior.expanded:
          collapsed = false;
          break;
        case ContentWarningBehavior.automatic:
          final plainText = renderedContent?.toPlainText(
            includeSemanticsLabels: false,
            includePlaceholders: false,
          );

          final strings = [if (plainText != null) plainText, subject];

          if (strings.isEmpty) break;

          final words = strings
              .map((e) => e.toLowerCase())
              .map((e) => e.split(RegExp(r"([\s:])+")))
              .flattened;

          collapsed = sensitiveWords.any(words.contains);
          break;
      }
    }
  }

  void _renderContent() {
    final post = widget.post;

    if (post.content == null) {
      renderedContent = null;
    } else {
      renderedContent = post.renderContent(
        context,
        ref,
        showReplyees: widget.showReplyee,
      );
    }
  }
}

class _PostWidgetState extends ConsumerState<PostWidget> {
  late Post _post;
  Post? _translatedPost;
  final _interactionBarKey = GlobalKey<InteractionBarState>();

  Map<Type, Action<Intent>> get _actions {
    return {
      ReplyIntent: CallbackAction(onInvoke: (_) => _onReply),
      FavoriteIntent: CallbackAction(onInvoke: (_) => _onFavorite()),
      RepeatIntent: CallbackAction(onInvoke: (_) => _onRepeat()),
      BookmarkIntent: CallbackAction(onInvoke: (_) => _onBookmark()),
      ReactIntent: CallbackAction(onInvoke: (_) => _onReact()),
      OpenMenuIntent: CallbackAction(
        onInvoke: (_) => _interactionBarKey.currentState?.showMenu(),
      ),
    };
  }

  VoidCallback? get _onTap {
    final showOpenButton = ref.watch(showDedicatedPostOpenButton).value;
    return widget.onTap ?? (showOpenButton ? null : widget.onOpen);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final repeatOf = _post.repeatOf;
    if (repeatOf != null) {
      return Column(
        children: [
          InkWell(
            onTap: () => context.showUser(_post.author, ref),
            child: InteractionEventBar(
              icon: Icons.repeat_rounded,
              text: l10n.postRepeated,
              color: Theme.of(context).ktkColors?.repeatColor ??
                  DefaultKaitekiColors(context).repeatColor,
              user: _post.author,
            ),
          ),
          PostWidget(
            repeatOf,
            showActions: widget.showActions,
            layout: widget.layout,
            onOpen: widget.onOpen,
          ),
        ],
      );
    }

    final adapter = ref.watch(adapterProvider);

    final isExpanded = widget.layout == PostWidgetLayout.expanded;
    final isWide = widget.layout == PostWidgetLayout.wide;
    final outlineColor = Theme.of(context).colorScheme.outline;
    final outlineTextStyle = outlineColor.textStyle;

    final signature = buildSignature(context);
    const padding = EdgeInsets.all(8);

    final children = [
      InkWell(
        onTap: (isWide || isExpanded) ? showAuthor : null,
        child: MetaBar(
          post: _post,
          showAvatar: widget.showAvatar && (isWide || isExpanded),
          showTime: widget.showTime ?? !isExpanded,
          showVisibility: widget.showVisibility ?? !isExpanded,
          twolineAuthor: isWide || isExpanded,
          onOpen: ref.watch(showDedicatedPostOpenButton).value
              ? widget.onOpen
              : null,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(right: padding.right),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.showParentPost && _post.replyToUser != null)
              ReplyBar(post: _post),
            _PostContent(
              post: _translatedPost ?? _post,
              showReplyee: widget.showReplyee,
              onTap: _onTap,
            ),
            if (signature != null) ...signature,
            if (_post.reactions.isNotEmpty) ...[
              spacer,
              ReactionRow(_post.reactions, (r) => _onChangeReaction(r.emoji)),
            ],
          ],
        ),
      ),
    ];

    const leftPostContentInset = 8 + 48;

    final clientText = _buildExpandedMetaBeta();

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
        child: Semantics(
          customSemanticsActions: _getSemanticsActions(context, adapter),
          child: Padding(
            padding: padding.copyWith(
              bottom: 0.0,
              right: 0.0,
              top: isWide || isExpanded ? null : 0.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!(isWide || isExpanded) && widget.showAvatar) ...[
                      Padding(
                        padding: EdgeInsets.only(top: padding.top),
                        child: AvatarWidget(
                          _post.author,
                          onTap: showAuthor,
                          focusNode: FocusNode(skipTraversal: true),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children,
                      ),
                    )
                  ],
                ),
                if (isExpanded) const Divider(height: 25),
                if (isExpanded)
                  OverflowBar(
                    spacing: 16.0,
                    overflowSpacing: 8.0,
                    children: [
                      Text(
                        DateFormat.yMMMMd(
                          Localizations.localeOf(context).toString(),
                        ).add_jm().format(_post.postedAt),
                        style: outlineTextStyle,
                      ),
                      if (_post.visibility != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _post.visibility!.toIconData(),
                              size: 16,
                              color: outlineColor,
                            ),
                            const SizedBox(width: 3.0),
                            Text(
                              _post.visibility!.toDisplayString(l10n),
                              style: outlineTextStyle,
                            ),
                          ],
                        ),
                      if (clientText != null) clientText,
                    ],
                  ),
                if (isExpanded) const Divider(height: 25),
                if (isExpanded) PostMetricBar(_post.metrics),
                if (widget.showActions) ...[
                  if (isExpanded)
                    Padding(
                      padding: EdgeInsets.only(
                        top: 12.0,
                        bottom: kPostPadding.bottom,
                      ),
                      child: const Divider(height: 1),
                    ),
                  Semantics(
                    focusable: false,
                    child: Padding(
                      padding: isExpanded || isWide
                          ? EdgeInsets.zero
                          : const EdgeInsets.only(
                              left: leftPostContentInset - 8,
                            ),
                      child: InteractionBar(
                        metrics: _post.metrics,
                        onReply: _onReply,
                        onFavorite: _onFavorite,
                        onRepeat: _onRepeat,
                        onReact: _onReact,
                        showLabels: !isExpanded,
                        spread: isExpanded,
                        favorited: adapter is FavoriteSupport //
                            ? _post.state.favorited
                            : null,
                        onShowFavoritees: () => context.pushNamed(
                          "postFavorites",
                          pathParameters: {
                            ...ref.accountRouterParams,
                            "id": _post.id,
                          },
                        ),
                        onShowRepeatees: () => context.pushNamed(
                          "postRepeats",
                          pathParameters: {
                            ...ref.accountRouterParams,
                            "id": _post.id,
                          },
                        ),
                        repeated: _post.state.repeated,
                        reacted: adapter is ReactionSupport ? false : null,
                        menuChildren: _buildMenuItems(context),
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
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

  MenuItemButton buildOpenInBrowserMenuItem(BuildContext context) {
    final l10n = context.l10n;
    final openInBrowserAvailable = _post.externalUrl != null;

    return MenuItemButton(
      leadingIcon: const Icon(Icons.open_in_new_rounded),
      onPressed: !openInBrowserAvailable
          ? null
          : () async {
              final url = _post.externalUrl;
              if (url == null) return;
              await launchUrl(url, mode: LaunchMode.externalApplication);
            },
      child: Text(l10n.openInBrowserLabel),
    );
  }

  List<Widget>? buildSignature(BuildContext context) {
    final showSig = ref.watch(AppExperiment.userSignatures.provider);

    if (!showSig || _post.author.description?.isNotEmpty != true) return null;

    final outlineColor = Theme.of(context).colorScheme.outline;
    final outlineTextStyle = outlineColor.textStyle;
    return [
      const SizedBox(
        width: 48,
        child: Divider(height: 25),
      ),
      Text.rich(
        _post.author.renderDescription(context, ref),
        style: outlineTextStyle,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ];
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

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  Future<void> showAuthor() async => context.showUser(_post.author, ref);

  List<Widget> _buildMenuItems(BuildContext context) {
    final adapter = ref.read(adapterProvider);

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
      buildOpenInBrowserMenuItem(context),
      if (_post.content != null &&
          ref.watch(preferences.developerMode).value) ...[
        const Divider(),
        buildDebugTextRenderingMenuItem(context),
      ]
    ];
  }

  Widget? _buildExpandedMetaBeta() {
    final client = _post.client;

    if (client == null) return null;

    return Text(
      client,
      style: Theme.of(context).colorScheme.outline.textStyle,
    );
  }

  Map<CustomSemanticsAction, VoidCallback> _getSemanticsActions(
    BuildContext context,
    BackendAdapter adapter,
  ) {
    return {
      CustomSemanticsAction(
        label: context.l10n.replyButtonLabel,
      ): _onReply,
      if (adapter is FavoriteSupport)
        CustomSemanticsAction(
          label: context.l10n.favoriteButtonLabel,
        ): _onFavorite,
      CustomSemanticsAction(
        label: context.l10n.repeatButtonLabel,
      ): _onRepeat,
      CustomSemanticsAction(
        label: context.l10n.bookmarkButtonLabel,
      ): _onBookmark,
      CustomSemanticsAction(
        label: context.l10n.reactButtonLabel,
      ): _onReact,
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
    }
  }

  Future<void> _onChangeReaction(Emoji emoji) async {
    final messenger = ScaffoldMessenger.of(context);
    final account = ref.read(accountProvider)!;
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
    }
  }

  void _onReply() {
    context.pushNamed(
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

  MenuItemButton buildShareMenuItem(BuildContext context) {
    return MenuItemButton(
      leadingIcon: const Icon(Icons.share_rounded),
      onPressed: () => share(context, _post),
      child: Text(context.l10n.shareButtonLabel),
    );
  }
}
