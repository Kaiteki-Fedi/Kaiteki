import "dart:math";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart" hide Visibility;
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/constants.dart" show bottomSheetConstraints;
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/interfaces/custom_emoji_support.dart";
import "package:kaiteki/fediverse/interfaces/search_support.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/model/file.dart";
import "package:kaiteki/model/language.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/adaptive_menu_anchor.dart";
import "package:kaiteki/ui/shared/dialogs/find_user_dialog.dart";
import "package:kaiteki/ui/shared/dialogs/missing_description.dart";
import "package:kaiteki/ui/shared/dialogs/post_too_long_dialog.dart";
import "package:kaiteki/ui/shared/emoji/emoji_selector_bottom_sheet.dart";
import "package:kaiteki/ui/shared/enum_icon_button.dart";
import "package:kaiteki/ui/shared/posts/compose/attachment_text_dialog.dart";
import "package:kaiteki/ui/shared/posts/compose/attachment_tray.dart";
import "package:kaiteki/ui/shared/posts/compose/post_preview.dart";
import "package:kaiteki/ui/shortcuts/activators.dart";
import "package:kaiteki/ui/shortcuts/intents.dart";
import "package:kaiteki/ui/shortcuts/shortcuts.dart";
import "package:kaiteki/utils/extensions.dart";

const double splashRadius = 20.0;

class ComposeForm extends ConsumerStatefulWidget {
  final Post? replyTo;
  final bool enableSubject;
  final bool showPreview;
  final bool expands;
  final VoidCallback? onSubmit;

  const ComposeForm({
    super.key,
    this.replyTo,
    this.enableSubject = true,
    this.showPreview = false,
    this.expands = false,
    this.onSubmit,
  });

  @override
  ConsumerState<ComposeForm> createState() => ComposeFormState();
}

class ComposeFormState extends ConsumerState<ComposeForm> {
  late final TextEditingController _bodyController;
  late final TextEditingController _subjectController;
  final List<AttachmentDraft> attachments = [];
  var _visibility = Visibility.public;
  Formatting? _formatting;
  late String _language;

  String? get initialBody {
    final op = widget.replyTo;

    if (op != null) {
      final currentUser = ref.read(accountProvider)!.user;

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

  bool get isEmpty {
    return (_bodyController.text.isEmpty ||
            _bodyController.text == initialBody) &&
        _subjectController.value.text.isEmpty &&
        attachments.isEmpty;
  }

  // FIXME(Craftplacer): Strings for PostForm's attach menu are not localized.
  late final _attachMenuItems = [
    AttachMenuItem(
      label: "Attach files",
      icon: Icons.insert_drive_file_rounded,
      onPressed: onAttachFile,
    ),
    const AttachMenuItem(
      label: "Take picture",
      icon: Icons.camera_rounded,
      onPressed: null,
    ),
    const AttachMenuItem(
      label: "Create poll",
      icon: Icons.poll_rounded,
      onPressed: null,
    ),
    const AttachMenuItem(
      label: "Record voice",
      icon: Icons.mic_rounded,
      onPressed: null,
    ),
  ];

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final opLanguage = widget.replyTo?.language;
    _language = opLanguage ?? Localizations.localeOf(context).languageCode;
  }

  int get flex => widget.expands ? 1 : 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Shortcuts(
      shortcuts: propagatingTextFieldShortcuts,
      child: FocusableActionDetector(
        shortcuts: const {commit: SendIntent()},
        actions: {
          SendIntent: CallbackAction(
            onInvoke: (_) => post(context),
          ),
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: flex,
              // HACK(Craftplacer): I wanted to settle on a `AnimatedCrossFade`
              // but given how ass it is to layout `TextField`s and make them
              // responsive, they give me too many problems with constraints
              // and bounds, so I just give up on making it look fancy.
              child: widget.showPreview
                  ? PostPreview(draft: postDraft)
                  : buildEdit(context),
            ),
            if (attachments.isNotEmpty) ...[
              const Divider(height: 1),
              AttachmentTray(
                attachments: attachments,
                onRemoveAttachment: (i) => setState(() {
                  attachments.removeAt(i);
                }),
                onToggleSensitive: (i) => setState(() {
                  attachments[i] = attachments[i].copyWith(
                    isSensitive: !attachments[i].isSensitive,
                  );
                }),
                onChangeDescription: (i) async {
                  final attachment = attachments[i];
                  final description = await showDialog<String>(
                    context: context,
                    builder: (context) => AttachmentTextDialog(
                      attachment: attachment,
                    ),
                  );

                  if (description != null) {
                    setState(() {
                      attachments[i] =
                          attachments[i].copyWith(description: description);
                    });
                  }
                },
              ),
            ],
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 10.0,
                top: 8.0,
                bottom: 8.0,
              ),
              child: Row(
                children: [
                  ..._buildActions(context),
                  const Spacer(),
                  FloatingActionButton.small(
                    elevation: Theme.of(context).useMaterial3 ? 0.0 : 2.0,
                    onPressed: () => post(context),
                    tooltip: l10n.submitButtonTooltip,
                    child: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEdit(BuildContext context) {
    final adapter = ref.watch(adapterProvider);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.enableSubject)
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
          Flexible(
            flex: flex,
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.composeBodyHint,
                border: InputBorder.none,
                isCollapsed: true,
              ),
              textAlignVertical: TextAlignVertical.top,
              expands: widget.expands,
              minLines: widget.expands ? null : 6,
              maxLines: widget.expands ? null : 8,
              controller: _bodyController,
              maxLength: adapter.capabilities.maxPostContentLength,
              maxLengthEnforcement: MaxLengthEnforcement.none,
            ),
          ),
        ],
      ),
    );
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
    );
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

  Future<void> post(BuildContext context) async {
    final adapter = ref.read(adapterProvider);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final goRouter = GoRouter.of(context);

    // pin state
    final draft = postDraft;
    final draftAttachments = attachments;

    final maxPostContentLength = adapter.capabilities.maxPostContentLength;
    if (maxPostContentLength != null &&
        draft.content.length >= maxPostContentLength) {
      await showDialog(
        context: context,
        builder: (_) => PostTooLongDialog(characterLimit: maxPostContentLength),
      );
      return;
    }
    if (await _checkForUndescribedAttachments(draftAttachments)) return;

    Future<Post> submitPost() async {
      final attachments = await Future.wait(
        draftAttachments.map(adapter.uploadAttachment),
      );
      return adapter.postStatus(draft.copyWith(attachments: attachments));
    }

    var snackBarController = messenger.showSnackBar(
      SnackBar(content: Text(l10n.postSubmissionSending)),
    );

    final accountRouterParams = ref.accountRouterParams;

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
                pathParameters: {...accountRouterParams, "id": post.id},
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
            label: l10n.whyButtonLabel,
            onPressed: () => context.showExceptionDialog((e, s)),
          ),
        ),
      );
    });

    widget.onSubmit?.call();
  }

  Future<void> openEmojiPicker() async {
    final emoji = await showModalBottomSheet<Emoji?>(
      context: context,
      constraints: bottomSheetConstraints,
      builder: (_) => const EmojiSelectorBottomSheet(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      elevation: 16.0,
      clipBehavior: Clip.antiAlias,
    );

    if (emoji == null) return;

    final String text;

    if (emoji is UnicodeEmoji) {
      text = emoji.emoji;
    } else if (emoji is CustomEmoji) {
      text = ":${emoji.short}:";
    } else {
      throw UnimplementedError();
    }

    _bodyController.text = _bodyController.text += text;
  }

  void openAttachDrawer() {
    showModalBottomSheet(
      constraints: bottomSheetConstraints,
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
                for (var item in _attachMenuItems)
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(16.0),
                      ),
                    ),
                    onPressed: item.onPressed,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, size: 32),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(item.label),
                        )
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

  Future<void> onAttachFile() async {
    Navigator.pop(context);

    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "Select file to upload as attachment",
      lockParentWindow: true,
    );

    if (result == null) return;

    final pickedFile = result.files.first;
    final attachment = AttachmentDraft(
      file: KaitekiFile.path(pickedFile.path!, name: pickedFile.name),
    );

    setState(() => attachments.add(attachment));
  }

  List<Widget> _buildActions(BuildContext context) {
    final l10n = context.l10n;
    final adapter = ref.watch(adapterProvider);
    final formattingList = adapter.capabilities.supportedFormattings;
    final supportedScopes = adapter.capabilities.supportedScopes;
    final supportsLanguageTagging =
        adapter.capabilities.supportsLanguageTagging;
    return [
      IconButton(
        onPressed: openAttachDrawer,
        icon: const Icon(Icons.add_circle_rounded),
        splashRadius: splashRadius,
        tooltip: l10n.attachButtonTooltip,
      ),
      if (adapter is CustomEmojiSupport)
        IconButton(
          icon: const Icon(Icons.mood_rounded),
          splashRadius: splashRadius,
          tooltip: l10n.emojiButtonTooltip,
          onPressed: openEmojiPicker,
        ),
      if (adapter is SearchSupport)
        IconButton(
          icon: const Icon(Icons.alternate_email_rounded),
          splashRadius: splashRadius,
          tooltip: "Mention user",
          onPressed: () async {
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
          },
        ),
      const SizedBox(height: 24, child: VerticalDivider(width: 16)),
      if (supportedScopes.length >= 2)
        EnumIconButton<Visibility>(
          tooltip: l10n.visibilityButtonTooltip,
          onChanged: (value) => setState(() => _visibility = value),
          value: _visibility,
          values: supportedScopes,
          splashRadius: splashRadius,
          iconBuilder: (_, value) => Icon(value.toIconData()),
          textBuilder: (_, value) => Text(value.toDisplayString(l10n)),
          subtitleBuilder: (_, value) => Text(value.toDescription(l10n)),
        ),
      if (formattingList.length >= 2)
        EnumIconButton<Formatting>(
          tooltip: l10n.formattingButtonTooltip,
          onChanged: (value) => setState(() => _formatting = value),
          value: _formatting ?? formattingList.first,
          values: formattingList,
          splashRadius: splashRadius,
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

  void reset() {
    setState(() {
      _bodyController.clear();
      _subjectController.clear();
      attachments.clear();
    });
  }
}

class LanguageIcon extends StatelessWidget {
  const LanguageIcon(
    this.language, {
    super.key,
  });

  final String language;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      language.toUpperCase(),
      style: theme.ktkTextTheme?.monospaceTextStyle.fallback.copyWith(
        fontWeight: FontWeight.bold,
        color: IconTheme.of(context).color,
      ),
    );
  }
}

class LanguageSwitcher extends ConsumerWidget {
  final String language;
  final Function(String language) onSelected;

  const LanguageSwitcher({
    super.key,
    required this.language,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(languageListProvider.future),
      builder: (context, snapshot) {
        return AdaptiveMenu(
          builder: (context, onTap) {
            return IconButton(
              icon: LanguageIcon(language),
              tooltip: "Language",
              splashRadius: splashRadius,
              onPressed: snapshot.hasData ? onTap : null,
            );
          },
          itemBuilder: (context, onClose) {
            final visible = ref.watch(visibleLanguages).value;
            final languages = snapshot.data;
            var list = languages?.where((e) => visible.contains(e.code));

            if (list?.isEmpty ?? false) {
              list = languages?.where((e) {
                return Localizations.localeOf(context).languageCode == e.code ||
                    e.code == language;
              });
            }

            return [
              for (var tuple in list ?? <Language>[])
                MenuItemButton(
                  leadingIcon: const SizedBox.square(dimension: 24),
                  trailingIcon: language == tuple.code
                      ? const Icon(Icons.check)
                      : const SizedBox.square(dimension: 24),
                  onPressed: () {
                    onSelected.call(tuple.code);
                    onClose?.call();
                  },
                  child: Text(tuple.englishName ?? tuple.code),
                ),
              const Divider(),
              MenuItemButton(
                leadingIcon: const Icon(Icons.add),
                onPressed: () {
                  context.pushNamed("visibleLanguageSettings");
                  onClose?.call();
                },
                trailingIcon: const SizedBox.square(dimension: 24),
                child: const Text("Add a language"),
              ),
            ];
          },
        );
      },
    );
  }
}

class AttachMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const AttachMenuItem({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}
