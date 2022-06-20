import 'dart:math';

import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Visibility;
import 'package:go_router/go_router.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/interfaces/custom_emoji_support.dart';
import 'package:kaiteki/fediverse/interfaces/preview_support.dart';
import 'package:kaiteki/fediverse/model/model.dart';
import 'package:kaiteki/model/file.dart';
import 'package:kaiteki/ui/intents.dart';
import 'package:kaiteki/ui/shared/async_snackbar_content.dart';
import 'package:kaiteki/ui/shared/emoji/emoji_selector.dart';
import 'package:kaiteki/ui/shared/enum_icon_button.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';
import 'package:kaiteki/ui/shared/posts/compose/attachment_tray.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';
import 'package:kaiteki/ui/shortcut_keys.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:mdi/mdi.dart';

const double splashRadius = 20.0;

class PostForm extends ConsumerStatefulWidget {
  final Post? replyTo;
  final bool enableSubject;
  final bool expands;

  const PostForm({
    Key? key,
    this.replyTo,
    this.enableSubject = true,
    this.expands = false,
  }) : super(key: key);

  @override
  ConsumerState<PostForm> createState() => PostFormState();
}

class PostFormState extends ConsumerState<PostForm> {
  late final TextEditingController _bodyController = TextEditingController()
    ..addListener(_typingTimer.reset);

  late final TextEditingController _subjectController = TextEditingController()
    ..addListener(_typingTimer.reset);

  late final RestartableTimer _typingTimer = RestartableTimer(
    const Duration(seconds: 1),
    () {
      _typingTimer.cancel();
      setState(() {});
    },
  );

  var _visibility = Visibility.public;
  var _formatting = Formatting.plainText;
  final List<Future<Attachment>> attachments = [];

  bool get isEmpty =>
      _bodyController.value.text.isEmpty &&
      _subjectController.value.text.isEmpty &&
      attachments.isEmpty;

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
    final manager = ref.watch(accountProvider);
    final flex = widget.expands ? 1 : 0;
    final l10n = context.getL10n();

    return FocusableActionDetector(
      shortcuts: {commitKeySet: SendIntent()},
      actions: {
        SendIntent: CallbackAction(
          onInvoke: (_) => post(context, manager.adapter),
        ),
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (manager.adapter is PreviewSupport)
            ExpansionTile(
              title: Text(l10n.postPreviewTitle),
              children: [
                FutureBuilder(
                  future: getPreviewFuture(manager),
                  builder: buildPreview,
                ),
              ],
            ),
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
                            hintText: l10n.composeSubjectHint,
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
                  onPressed: () => post(context, manager.adapter),
                  elevation: 2.0,
                  tooltip: l10n.submitButtonTooltip,
                  child: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPreview(
    BuildContext context,
    AsyncSnapshot<Post<dynamic>> snapshot,
  ) {
    final l10n = context.getL10n();

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
              child: IconLandingWidget(
                icon: const Icon(Mdi.close),
                text: Text(snapshot.error.toString()),
              ),
            ),
          );
        } else {
          return PostWidget(snapshot.data!, showActions: false);
        }
    }

    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Future<Post>? getPreviewFuture(AccountManager manager) {
    if (_bodyController.value.text.isEmpty) return null;

    final draft = _getPostDraft([]);
    final previewAdapter = manager.adapter as PreviewSupport;
    return previewAdapter.getPreview(draft);
  }

  PostDraft _getPostDraft(List<Attachment> attachments) {
    return PostDraft(
      subject: _subjectController.value.text,
      content: _bodyController.value.text,
      visibility: _visibility,
      formatting: _formatting,
      replyTo: widget.replyTo,
      attachments: attachments,
    );
  }

  Future<void> post(BuildContext context, FediverseAdapter adapter) async {
    final messenger = ScaffoldMessenger.of(context);
    final contentKey = UniqueKey();
    final l10n = context.getL10n();

    Navigator.of(context).pop();

    final snackBar = SnackBar(
      duration: const Duration(days: 1),
      content: FutureBuilder<Post>(
        future: () async {
          final attachments = await Future.wait(this.attachments);
          final draft = _getPostDraft(attachments);
          return adapter.postStatus(draft);
        }(),
        builder: (context, snapshot) {
          switch (snapshot.state) {
            case AsyncSnapshotState.errored:
              Future.delayed(
                const Duration(seconds: 4),
                messenger.hideCurrentSnackBar,
              );
              return AsyncSnackBarContent(
                key: contentKey,
                done: true,
                icon: const Icon(Mdi.close),
                text: Text(l10n.postSubmissionFailed),
                trailing: TextButton(
                  child: Text(l10n.whyButtonLabel),
                  onPressed: () {},
                ),
              );

            case AsyncSnapshotState.loading:
              return AsyncSnackBarContent(
                key: contentKey,
                done: false,
                icon: const Icon(Mdi.textBox),
                text: Text(l10n.postSubmissionSending),
              );
          }

          Future.delayed(
            const Duration(seconds: 4),
            messenger.hideCurrentSnackBar,
          );

          return AsyncSnackBarContent(
            key: contentKey,
            done: true,
            icon: const Icon(Mdi.check),
            text: Text(l10n.postSubmissionSent),
            trailing: Consumer(
              builder: (context, ref, child) {
                return TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary,
                    ),
                    visualDensity: VisualDensity.comfortable,
                  ),
                  onPressed: () {
                    final post = snapshot.data!;
                    context.push(
                      "/${ref.getCurrentAccountHandle()}/posts/${post.id}",
                      extra: post,
                    );
                    messenger.hideCurrentSnackBar();
                  },
                  child: Text(l10n.viewPostButtonLabel),
                );
              },
            ),
          );
        },
      ),
    );

    messenger.showSnackBar(snackBar);
  }

  void openEmojiPicker(BuildContext context, AccountManager container) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: FutureBuilder(
            future: (container.adapter as CustomEmojiSupport).getEmojis(),
            builder: buildEmojiSelector,
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      elevation: 16.0,
      clipBehavior: Clip.antiAlias,
    );
  }

  Widget buildEmojiSelector(
    BuildContext context,
    AsyncSnapshot<Iterable<EmojiCategory>> s,
  ) {
    final l10n = context.getL10n();

    if (s.hasError) {
      return Center(child: Text(l10n.emojiRetrievalFailed));
    }

    if (!s.hasData) return const Center(child: CircularProgressIndicator());

    return EmojiSelector(
      categories: s.data!,
      onEmojiSelected: (emoji) {
        _bodyController.text = _bodyController.text += emoji.toString();
      },
    );
  }

  void openAttachDrawer() {
    showModalBottomSheet(
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
    final kaitekiFile = File.path(pickedFile.path!, name: pickedFile.name);
    final adapter = ref.watch(accountProvider).adapter;
    setState(
      () => attachments.add(adapter.uploadAttachment(kaitekiFile, null)),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final l10n = context.getL10n();
    final manager = ref.watch(accountProvider);
    return [
      IconButton(
        onPressed: openAttachDrawer,
        icon: const Icon(Icons.add_circle_rounded),
        splashRadius: splashRadius,
        tooltip: l10n.attachButtonTooltip,
      ),
      EnumIconButton<Visibility>(
        tooltip: l10n.visibilityButtonTooltip,
        onChanged: (value) => setState(() => _visibility = value),
        value: _visibility,
        values: Visibility.values,
        splashRadius: splashRadius,
        iconBuilder: (value) => Icon(value.toIconData()),
        textBuilder: (value) => Text(value.toDisplayString()),
      ),
      EnumIconButton<Formatting>(
        tooltip: l10n.formattingButtonTooltip,
        onChanged: (value) => setState(() => _formatting = value),
        value: _formatting,
        values: Formatting.values,
        splashRadius: splashRadius,
        iconBuilder: (value) => Icon(value.toIconData()),
        textBuilder: (value) => Text(value.toDisplayString()),
      ),
      if (manager.adapter is CustomEmojiSupport)
        IconButton(
          onPressed: () => openEmojiPicker(context, manager),
          icon: const Icon(Icons.mood_rounded),
          splashRadius: splashRadius,
          tooltip: l10n.emojiButtonTooltip,
        )
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
