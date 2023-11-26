import "dart:math";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart" hide Visibility;
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/dialogs/dialog_close_button.dart";
import "package:kaiteki/ui/shared/dialogs/find_user_dialog.dart";
import "package:kaiteki/ui/shared/dialogs/missing_description.dart";
import "package:kaiteki/ui/shared/dialogs/post_too_long_dialog.dart";
import "package:kaiteki/ui/shared/dialogs/responsive_dialog.dart";
import "package:kaiteki/ui/shared/emoji/emoji_selector_bottom_sheet.dart";
import "package:kaiteki/ui/shared/enum_icon_button.dart";
import "package:kaiteki/ui/shared/post_scope_icon.dart";
import "package:kaiteki/ui/shared/posts/compose/attachment_tray.dart";
import "package:kaiteki/ui/shared/posts/compose/discard_post_dialog.dart";
import "package:kaiteki/ui/shared/posts/compose/toggle_subject_button.dart";
import "package:kaiteki/ui/shared/posts/poll_widget.dart";
import "package:kaiteki/ui/shortcuts/activators.dart";
import "package:kaiteki/ui/shortcuts/intents.dart";
import "package:kaiteki/ui/shortcuts/shortcuts.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";

import "attachment_text_dialog.dart";
import "language_switcher.dart";
import "poll_dialog.dart";
import "post_preview.dart";

class ComposeScreen extends ConsumerStatefulWidget {
  final Post? replyTo;

  const ComposeScreen({super.key, this.replyTo});

  @override
  ConsumerState<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends ConsumerState<ComposeScreen> {
  late final TextEditingController _bodyController;
  late final TextEditingController _subjectController;
  final List<AttachmentDraft> attachments = [];
  var _visibility = PostScope.public;
  var _enableSubject = false;
  var _showPreview = false;
  Formatting? _formatting;
  PollDraft? _poll;
  late String _language;

  // FIXME(Craftplacer): Strings for PostForm's attach menu are not localized.
  late final _attachMenuItems = [
    (
      label: "Attach files",
      icon: Icons.insert_drive_file_rounded,
      onPressed: _onAttachFile,
    ),
    (
      label: "Create poll",
      icon: Icons.poll_rounded,
      onPressed: _onChangePoll,
    ),
  ];

  String? get initialBody {
    final op = widget.replyTo;

    if (op != null) {
      final currentUser = ref.read(currentAccountProvider)!.user;

      final handles = <String>[
        if (op.author.id != currentUser.id) op.author.handle.toString(),
        ...?op.mentionedUsers
            ?.where((u) => u.username != null && u.host != null)
            .where((u) {
          return !(u.username == currentUser.username &&
              u.host == currentUser.host);
        }).map((u) => "@${u.username!}@${u.host!}"),
      ].distinct();

      // ignore: prefer_interpolation_to_compose_strings
      if (handles.isNotEmpty) return handles.join(" ") + " ";
    }

    return null;
  }

  Future<void> _onChangePoll() async {
    final poll = await showDialog(
      context: context,
      builder: (_) => PollDialog(poll: _poll),
    );

    if (poll == null) return;

    setState(() => _poll = poll);
  }

  bool get isEmpty {
    return (_bodyController.text.isEmpty ||
            _bodyController.text == initialBody) &&
        _subjectController.value.text.isEmpty &&
        attachments.isEmpty &&
        _poll == null;
  }

  PostDraft get postDraft {
    final subject =
        _subjectController.text.isEmpty ? null : _subjectController.text;
    final content = _bodyController.value.text;

    return PostDraft(
      subject: subject,
      content: content,
      visibility: _visibility,
      formatting: _formatting ?? Formatting.plainText,
      replyTo: widget.replyTo,
      language: _language,
      poll: _poll,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final adapter = ref.watch(adapterProvider);
    final replyTo = widget.replyTo;
    TextSpan? replyTextSpan;

    if (replyTo != null) {
      replyTextSpan = TextSpan(
        text: l10n.composeDialogTitleReply,
        children: [replyTo.author.renderDisplayName(context, ref)],
      );
    }

    final closeButton = (ModalRoute.of(context)?.canPop ?? false)
        ? DialogCloseButton(tooltip: l10n.discardButtonTooltip)
        : null;

    final backgroundColor = switch (Theme.of(context).colorScheme.brightness) {
      Brightness.light =>
        Theme.of(context).colorScheme.corePalette.neutral.get(95),
      Brightness.dark =>
        Theme.of(context).colorScheme.corePalette.neutral.get(10),
    };

    return PopScope(
      canPop: false,
      onPopInvoked: _onPopInvoked,
      child: ResponsiveDialog(
        backgroundColor: Color(backgroundColor),
        builder: (context, axis) {
          final fullscreen = axis != null;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (axis != Axis.vertical)
                AppBar(
                  actions: [
                    if (adapter.capabilities.supportsSubjects)
                      ToggleSubjectButton(
                        value: _enableSubject,
                        onChanged: _showPreview ? null : toggleSubject,
                      ),
                    if (!fullscreen && closeButton != null) closeButton,
                    kAppBarActionsSpacer,
                  ],
                  automaticallyImplyLeading: false,
                  leading:
                      fullscreen && closeButton != null ? closeButton : null,
                  title: replyTextSpan == null
                      ? Text(l10n.composeDialogTitle)
                      : Text.rich(replyTextSpan),
                  forceMaterialTransparency: true,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                ),
              Expanded(
                flex: fullscreen ? 1 : 0,
                child: buildForm(fullscreen),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildEdit(BuildContext context, bool expands) {
    final adapter = ref.watch(adapterProvider);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_enableSubject)
            Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: l10n.composeContentWarningHint,
                    border: InputBorder.none,
                  ),
                  controller: _subjectController,
                ),
                const Divider(),
                const SizedBox(height: 8),
              ],
            ),
          Expanded(
            flex: expands ? 1 : 0,
            child: TextField(
              autofocus: true,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: l10n.composeBodyHint,
                border: InputBorder.none,
              ),
              contentInsertionConfiguration: ContentInsertionConfiguration(
                onContentInserted: _onContentInserted,
              ),
              textAlignVertical: TextAlignVertical.top,
              expands: expands,
              minLines: expands ? null : 6,
              maxLines: expands ? null : 8,
              controller: _bodyController,
              maxLength: adapter.capabilities.maxPostContentLength,
              maxLengthEnforcement: MaxLengthEnforcement.none,
            ),
          ),
          if (_poll != null) ...[
            const Divider(height: 16 + 1),
            MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  leadingIcon: const Icon(Icons.edit_rounded),
                  onPressed: _onChangePoll,
                  child: const Text("Edit poll"),
                ),
                MenuItemButton(
                  leadingIcon: const Icon(Icons.delete_rounded),
                  onPressed: () => setState(() => _poll = null),
                  child: const Text("Remove poll"),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DraftPollWidget(_poll!),
              ),
              builder: (context, controller, child) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTapUp: (details) {
                      controller.open(position: details.localPosition);
                    },
                    child: child,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget buildForm(bool expands) {
    final l10n = context.l10n;
    const minimal = false;

    final backgroundColor = switch (Theme.of(context).colorScheme.brightness) {
      Brightness.light =>
        Color(Theme.of(context).colorScheme.corePalette.neutral.get(98)),
      Brightness.dark => Theme.of(context).colorScheme.background,
    };
    return Shortcuts(
      shortcuts: propagatingTextFieldShortcuts,
      child: FocusableActionDetector(
        shortcuts: const {commit: SendIntent()},
        actions: {
          SendIntent: CallbackAction(
            onInvoke: (_) => _post(context),
          ),
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: expands ? 1 : 0,
              child: minimal
                  // ignore: dead_code
                  ? Row(
                      children: [
                        Expanded(child: buildEdit(context, expands)),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: FilledButton.icon(
                            label: Text(l10n.submitButtonTooltip),
                            onPressed: () => _post(context),
                            icon: const Icon(Icons.send_rounded),
                            style: FilledButton.styleFrom(
                              visualDensity: VisualDensity.standard,
                            ),
                          ),
                        ),
                      ],
                    )
                  // HACK(Craftplacer): I wanted to settle on a, `AnimatedCrossFade`
                  // but given how ass it is to layout `TextField`s and make them
                  // responsive, they give me too many problems with constraints
                  // and bounds, so I just give up on making it look fancy.
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Material(
                        color: backgroundColor,
                        shape: Shapes.medium,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex: expands ? 1 : 0,
                              child: _showPreview
                                  ? PostPreview(draft: postDraft)
                                  : buildEdit(context, expands),
                            ),
                            if (attachments.isNotEmpty) ...[
                              const Divider(height: 1, indent: 8, endIndent: 8),
                              AttachmentTray(
                                attachments: attachments,
                                onRemoveAttachment: (index) {
                                  setState(() => attachments.removeAt(index));
                                },
                                onToggleSensitive: _onToggleSensitive,
                                onChangeDescription: _onChangeDescription,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
            ),
            if (!minimal) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: _buildActions(context)),
                      ),
                    ),
                    IconButton.outlined(
                      isSelected: _showPreview,
                      onPressed: togglePreview,
                      icon: const Icon(Icons.preview_rounded),
                      tooltip: "Toggle preview",
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.standard,
                        elevation: Theme.of(context).useMaterial3 ? 0.0 : 2.0,
                      ),
                      onPressed: () => _post(context),
                      label: Text(l10n.submitButtonTooltip),
                      icon: const Icon(Icons.send_rounded, size: 16),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final opLanguage = widget.replyTo?.language;
    _language = opLanguage ?? Localizations.localeOf(context).languageCode;
  }

  @override
  void initState() {
    super.initState();

    final op = widget.replyTo;
    if (op?.visibility != null) {
      _visibility = op!.visibility!;
    }

    _bodyController = TextEditingController(text: initialBody)
      ..addListener(() => setState(() {}));
    _subjectController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  void reset() {
    setState(() {
      _bodyController.clear();
      _subjectController.clear();
      attachments.clear();
    });
  }

  void togglePreview() => setState(() => _showPreview = !_showPreview);

  void toggleSubject() => setState(() => _enableSubject = !_enableSubject);

  List<Widget> _buildActions(BuildContext context) {
    final l10n = context.l10n;
    final adapter = ref.watch(adapterProvider);
    final formattingList = adapter.capabilities.supportedFormattings;
    final supportedScopes = adapter.capabilities.supportedScopes;
    final supportsLanguageTagging =
        adapter.capabilities.supportsLanguageTagging;
    return [
      IconButton(
        onPressed: _openAttachDrawer,
        icon: const Icon(Icons.add_circle_rounded),
        splashRadius: 24,
        tooltip: l10n.attachButtonTooltip,
      ),
      if (adapter is CustomEmojiSupport)
        IconButton(
          icon: const Icon(Icons.mood_rounded),
          splashRadius: 24,
          tooltip: l10n.emojiButtonTooltip,
          onPressed: _openEmojiPicker,
        ),
      if (adapter is SearchSupport)
        IconButton(
          icon: const Icon(Icons.alternate_email_rounded),
          splashRadius: 24,
          tooltip: "Mention user",
          onPressed: _onMentionUser,
        ),
      const SizedBox(height: 24, child: VerticalDivider(width: 16)),
      if (supportedScopes.length >= 2)
        EnumIconButton<PostScope>(
          tooltip: l10n.visibilityButtonTooltip,
          onChanged: (value) => setState(() => _visibility = value),
          value: _visibility,
          values: supportedScopes,
          splashRadius: 24,
          iconBuilder: (_, value) => PostScopeIcon(value),
          textBuilder: (_, value) => Text(value.toDisplayString(l10n)),
          subtitleBuilder: (_, value) => Text(value.toDescription(l10n)),
        ),
      if (formattingList.length >= 2)
        EnumIconButton<Formatting>(
          tooltip: l10n.formattingButtonTooltip,
          onChanged: (value) => setState(() => _formatting = value),
          value: _formatting ?? formattingList.first,
          values: formattingList,
          splashRadius: 24,
          iconBuilder: (_, value) => Icon(value.toIconData()),
          textBuilder: (_, value) => Text(value.toDisplayString(l10n)),
        ),
      if (supportsLanguageTagging)
        LanguageSwitcher(
          language: _language,
          onSelected: (language) => setState(() => _language = language),
        ),
    ];
  }

  /// Shows a attachment description reminder when enabled and there's at least
  /// one attachment without description.
  ///
  /// Returns true, if the user cancelled the post submission. Returns false, if
  /// reminders are disabled or the user acknowledged the dialog.
  Future<bool> _checkForUndescribedAttachments(
    List<AttachmentDraft> attachments,
  ) async {
    final showMissingDescriptionWarnings =
        ref.read(showAttachmentDescriptionWarning).value;
    final hasUndescribedAttachments = attachments.any((e) {
      return e.description == null || e.description!.isEmpty;
    });

    if (showMissingDescriptionWarnings && hasUndescribedAttachments) {
      final result = await showDialog(
        context: context,
        builder: (context) => const MissingDescriptionDialog(),
      );
      if (result != true) return true;
    }

    return false;
  }

  Future<bool> _checkLength(BackendAdapter adapter, PostDraft draft) async {
    final maxPostContentLength = adapter.capabilities.maxPostContentLength;
    if (maxPostContentLength != null &&
        draft.content.length >= maxPostContentLength) {
      await showDialog(
        context: context,
        builder: (_) => PostTooLongDialog(characterLimit: maxPostContentLength),
      );
      return true;
    }

    return false;
  }

  Future<void> _onAttachFile() async {
    Navigator.pop(context);

    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "Select file to upload as attachment",
      lockParentWindow: true,
      allowMultiple: true,
    );

    if (result == null) return;

    setState(() {
      attachments.addAll(
        result.files.map(
          (e) => AttachmentDraft(file: KaitekiLocalFile(e.path!)),
        ),
      );
    });
  }

  Future<void> _onChangeDescription(int index) async {
    final attachment = attachments[index];
    final description = await showDialog<String>(
      context: context,
      builder: (context) => AttachmentTextDialog(attachment: attachment),
    );

    if (description == null) return;

    setState(() {
      attachments[index] = attachment.copyWith(description: description);
    });
  }

  void _onContentInserted(KeyboardInsertedContent value) {
    final AttachmentDraft draft;

    if (value.hasData) {
      draft = AttachmentDraft(
        file: KaitekiMemoryFile(value.data!),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kaiteki cannot handle insertion of URLs."),
        ),
      );
      return;
    }

    setState(() => attachments.add(draft));
  }

  Future<void> _onMentionUser() async {
    final user = await showDialog<User>(
      context: context,
      builder: (_) => const FindUserDialog(),
    );

    if (user == null) return;

    final cursor = _bodyController.selection.baseOffset;
    final prefix = _bodyController.text.substring(0, cursor);
    final suffix = _bodyController.text.substring(cursor);
    final handle = user.handle;
    _bodyController.text = "$prefix$handle $suffix";
  }

  Future<void> _onPopInvoked(bool didPop) async {
    final navigator = Navigator.of(context);

    if (didPop) return;

    if (!isEmpty) {
      final dialogResult = await showDialog(
        context: context,
        builder: (_) => const DiscardPostDialog(),
      );

      if (dialogResult != true) return;
    }

    navigator.pop();
  }

  void _onToggleSensitive(index) {
    final attachment = attachments[index];
    setState(() {
      attachments[index] = attachment.copyWith(
        isSensitive: !attachment.isSensitive,
      );
    });
  }

  void _openAttachDrawer() {
    showModalBottomSheet(
      constraints: kBottomSheetConstraints,
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, data) {
            final columns = max((data.maxWidth ~/ 300) * 2, 2);
            final itemWidth = data.maxWidth / columns;
            final itemAspectRatio = itemWidth / 96;

            return GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              childAspectRatio: itemAspectRatio,
              padding: const EdgeInsets.all(8.0),
              children: [
                for (final item in _attachMenuItems)
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                    ),
                    onPressed: item.onPressed,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, size: 32),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        );
      },
      elevation: 24,
    );
  }

  Future<void> _openEmojiPicker() async {
    final emoji = await showModalBottomSheet<Emoji?>(
      context: context,
      constraints: kBottomSheetConstraints,
      builder: (_) => const EmojiSelectorBottomSheet(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      elevation: 16.0,
      clipBehavior: Clip.antiAlias,
      useSafeArea: true,
    );

    if (emoji == null) return;

    final text = switch (emoji) {
      UnicodeEmoji() => emoji.emoji,
      CustomEmoji() => ":${emoji.short}:",
      _ => throw UnimplementedError(),
    };

    _bodyController.text = _bodyController.text += text;
  }

  Future<void> _post(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l10n = context.l10n;
    final goRouter = GoRouter.of(context);
    final adapter = ref.read(adapterProvider);
    final routeParams = ref.accountRouterParams;

    // pin state
    final draft = postDraft;
    final draftAttachments = attachments;

    if (await _checkLength(adapter, draft)) return;
    if (await _checkForUndescribedAttachments(draftAttachments)) return;

    Future<Post> submitPost() async {
      final attachments = await Future.wait(
        draftAttachments.map(adapter.uploadAttachment),
      );
      return adapter.postStatus(draft.copyWith(attachments: attachments));
    }

    navigator.pop();

    var snackBarController = messenger.showSnackBar(
      SnackBar(content: Text(l10n.postSubmissionSending)),
    );

    submitPost().then((post) {
      snackBarController.close();
      snackBarController = messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.postSubmissionSent),
          action: SnackBarAction(
            label: l10n.viewPostButtonLabel,
            onPressed: () {
              goRouter.pushNamed(
                "post",
                pathParameters: {...routeParams, "id": post.id},
                extra: post,
              );
              messenger.hideCurrentSnackBar();
            },
          ),
        ),
      );
    }).catchError((e, s) {
      snackBarController.close();
      snackBarController = messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.postSubmissionFailed),
          action: SnackBarAction(
            label: l10n.showDetailsButtonLabel,
            onPressed: () => navigator.context.showExceptionDialog((e, s)),
          ),
        ),
      );
    });
  }
}
