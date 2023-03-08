import "dart:math";

import "package:async/async.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart" hide Visibility;
import "package:go_router/go_router.dart";
import "package:kaiteki/constants.dart" show bottomSheetConstraints;
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/interfaces/custom_emoji_support.dart";
import "package:kaiteki/fediverse/interfaces/preview_support.dart";
import "package:kaiteki/fediverse/interfaces/search_support.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/model/file.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/dialogs/find_user_dialog.dart";
import "package:kaiteki/ui/shared/emoji/emoji_selector_bottom_sheet.dart";
import "package:kaiteki/ui/shared/enum_icon_button.dart";
import "package:kaiteki/ui/shared/error_landing_widget.dart";
import "package:kaiteki/ui/shared/posts/compose/attachment_text_dialog.dart";
import "package:kaiteki/ui/shared/posts/compose/attachment_tray.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
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
  ConsumerState<ComposeForm> createState() => PostFormState();
}

class PostFormState extends ConsumerState<ComposeForm> {
  late final TextEditingController _bodyController =
      TextEditingController(text: initialBody)..addListener(_typingTimer.reset);

  late final TextEditingController _subjectController = TextEditingController()
    ..addListener(_typingTimer.reset);

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

  late final RestartableTimer _typingTimer = RestartableTimer(
    const Duration(seconds: 1),
    () {
      _typingTimer.cancel();
      setState(() {});
    },
  );

  var _visibility = Visibility.public;
  Formatting? _formatting;
  final List<AttachmentDraft> attachments = [];

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
  void dispose() {
    super.dispose();

    _typingTimer.cancel();
  }

  @override
  void initState() {
    super.initState();

    final op = widget.replyTo;
    if (op?.visibility != null) {
      _visibility = op!.visibility!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final adapter = ref.watch(adapterProvider);
    final flex = widget.expands ? 1 : 0;
    final l10n = context.l10n;

    return Shortcuts(
      shortcuts: propagatingTextFieldShortcuts,
      child: FocusableActionDetector(
        shortcuts: const {commit: SendIntent()},
        actions: {
          SendIntent: CallbackAction(
            onInvoke: (_) => post(context, adapter),
          ),
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showPreview && adapter is PreviewSupport) ...[
              FutureBuilder(
                future: getPreviewFuture(adapter as PreviewSupport),
                builder: buildPreview,
              ),
              const Divider(height: 15),
            ],
            Flexible(
              flex: flex,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
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
                        ],
                      ),
                    Flexible(
                      flex: flex,
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: l10n.composeBodyHint,
                          border: InputBorder.none,
                        ),
                        textAlignVertical: TextAlignVertical.top,
                        expands: widget.expands,
                        minLines: widget.expands ? null : 6,
                        maxLines: widget.expands ? null : 8,
                        controller: _bodyController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (attachments.isNotEmpty) const Divider(height: 1),
            if (attachments.isNotEmpty)
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
                    onPressed: () => post(context, adapter),
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

  Widget buildPreview(
    BuildContext context,
    AsyncSnapshot<Post<dynamic>> snapshot,
  ) {
    final l10n = context.l10n;

    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(l10n.postPreviewWaiting)),
        );

      case ConnectionState.done:
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ErrorLandingWidget.fromAsyncSnapshot(snapshot),
            ),
          );
        } else {
          return PostWidget(snapshot.data!, showActions: false);
        }
    }

    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: centeredCircularProgressIndicator,
    );
  }

  Future<Post>? getPreviewFuture(PreviewSupport adapter) {
    if (_bodyController.value.text.isEmpty) return null;

    final draft = _getPostDraft([]);
    return adapter.getPreview(draft);
  }

  PostDraft _getPostDraft(List<Attachment> attachments) {
    return PostDraft(
      subject: _subjectController.text.isEmpty ? null : _subjectController.text,
      content: _bodyController.value.text,
      visibility: _visibility,
      formatting: _formatting ?? Formatting.plainText,
      replyTo: widget.replyTo,
      attachments: attachments,
    );
  }

  Future<void> post(BuildContext context, BackendAdapter adapter) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    Future<Post> submitPost() async {
      final attachments = await Future.wait(
        this.attachments.map(adapter.uploadAttachment),
      );
      final draft = _getPostDraft(attachments);
      return adapter.postStatus(draft);
    }

    var snackBarController = messenger.showSnackBar(
      SnackBar(content: Text(l10n.postSubmissionSending)),
    );

    final goRouter = GoRouter.of(context);
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
                params: {...accountRouterParams, "id": post.id},
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
            onPressed: () => context.showExceptionDialog(
              e as Object,
              s as StackTrace?,
            ),
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
      const SizedBox(
        height: 24,
        child: VerticalDivider(
          width: 16,
        ),
      ),
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
    ];
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
