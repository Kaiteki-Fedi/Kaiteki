import 'dart:math';

import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/interfaces/preview_support.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/fediverse/model/emoji_category.dart';
import 'package:kaiteki/fediverse/model/formatting.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/post_draft.dart';
import 'package:kaiteki/fediverse/model/visibility.dart' as v;
import 'package:kaiteki/model/file.dart';
import 'package:kaiteki/ui/widgets/async_snackbar_content.dart';
import 'package:kaiteki/ui/widgets/emoji/emoji_selector.dart';
import 'package:kaiteki/ui/widgets/enum_icon_button.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:kaiteki/ui/widgets/post_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:mdi/mdi.dart';

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
  ConsumerState<PostForm> createState() => _PostFormState();
}

class _PostFormState extends ConsumerState<PostForm> {
  late TextEditingController _bodyController;
  late TextEditingController _subjectController;
  late RestartableTimer _typingTimer;
  var _visibility = v.Visibility.public;
  var _formatting = Formatting.plainText;
  final List<Future<Attachment>> attachments = [];

  // FIXME(Craftplacer): Strings for PostForm's attach menu are not localized.
  late final _attachMenuItems = [
    AttachMenuItem(
      label: "Attach files",
      icon: Mdi.file,
      onPressed: onAttachFile,
    ),
    const AttachMenuItem(
      label: "Take picture",
      icon: Mdi.camera,
      onPressed: null,
    ),
    const AttachMenuItem(
      label: "Create poll",
      icon: Mdi.pollBox,
      onPressed: null,
    ),
    const AttachMenuItem(
      label: "Record voice",
      icon: Mdi.microphone,
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

    _typingTimer = RestartableTimer(
      const Duration(seconds: 1),
      () {
        _typingTimer.cancel();
        setState(() {});
      },
    );

    _bodyController = TextEditingController()..addListener(_typingTimer.reset);

    _subjectController = TextEditingController();
    _subjectController.addListener(_typingTimer.reset);

    if (widget.replyTo != null) {
      _visibility = widget.replyTo!.visibility;
    }
  }

  @override
  Widget build(BuildContext context) {
    final manager = ref.watch(accountProvider);
    final flex = widget.expands ? 1 : 0;
    final l10n = context.getL10n();

    return Column(
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
              IconButton(
                onPressed: openAttachDrawer,
                icon: const Icon(Mdi.plusCircle),
                splashRadius: 20,
                tooltip: l10n.attachButtonTooltip,
              ),
              EnumIconButton<v.Visibility>(
                tooltip: l10n.visibilityButtonTooltip,
                onChanged: (value) => setState(() => _visibility = value),
                value: _visibility,
                values: v.Visibility.values,
                iconBuilder: (value) => Icon(value.toIconData()),
                textBuilder: (value) => Text(value.toHumanString()),
              ),
              EnumIconButton<Formatting>(
                tooltip: l10n.formattingButtonTooltip,
                onChanged: (value) => setState(() => _formatting = value),
                value: _formatting,
                values: Formatting.values,
                iconBuilder: (value) => Icon(value.toIconData()),
                textBuilder: (value) => Text(value.toHumanString()),
              ),
              IconButton(
                onPressed: () => openEmojiPicker(context, manager),
                icon: const Icon(Mdi.emoticon),
                splashRadius: 20,
                tooltip: l10n.emojiButtonTooltip,
              ),
              const Spacer(),
              FloatingActionButton.small(
                onPressed: () => post(context, manager.adapter),
                elevation: 2.0,
                tooltip: l10n.submitButtonTooltip,
                child: const Icon(Mdi.send),
              ),
            ],
          ),
        ),
      ],
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
            future: container.adapter.getEmojis(),
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
}

class AttachmentTray extends StatelessWidget {
  final Function(int index)? onRemoveAttachment;

  const AttachmentTray({
    Key? key,
    required this.attachments,
    this.onRemoveAttachment,
  }) : super(key: key);

  final List<Future<Attachment>> attachments;

  @override
  Widget build(BuildContext context) {
    var i = 0;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < attachments.length; i++)
            AttachmentTrayItem(
              attachment: attachments[i],
              onRemove: () => onRemoveAttachment?.call(i),
            ),
        ],
      ),
    );
  }
}

class AttachmentTrayItem extends StatelessWidget {
  final VoidCallback? onRemove;

  const AttachmentTrayItem({
    Key? key,
    required this.attachment,
    this.onRemove,
  }) : super(key: key);

  final Future<Attachment> attachment;

  @override
  Widget build(BuildContext context) {
    const size = 72.0;

    return FutureBuilder(
      future: attachment,
      // ignore: avoid_types_on_closure_parameters
      builder: (context, AsyncSnapshot<Attachment> snapshot) {
        final Widget widget;

        if (snapshot.hasError) {
          widget = const Center(child: Icon(Icons.error));
        } else if (!snapshot.hasData) {
          widget = const Center(child: CircularProgressIndicator());
        } else {
          final attachment = snapshot.data!;
          switch (attachment.type) {
            case AttachmentType.image:
              widget = Image.network(
                snapshot.data!.url,
                fit: BoxFit.cover,
              );
              break;
            case AttachmentType.video:
              widget = const Center(child: Icon(Icons.video_file_rounded));
              break;
            case AttachmentType.audio:
              widget = const Center(child: Icon(Icons.audio_file_rounded));
              break;
            case AttachmentType.file:
            default:
              widget = const Center(child: Icon(Icons.upload_file_rounded));
              break;
          }
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(8.0),
            elevation: 4.0,
            child: Stack(
              children: [
                SizedBox(
                  width: size,
                  height: size,
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: widget,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: PopupMenuButton(
                    iconSize: 20,
                    splashRadius: 12,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    onSelected: (action) {
                      switch (action) {
                        case AttachmentTryItemAction.remove:
                          onRemove?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: AttachmentTryItemAction.remove,
                          enabled: onRemove != null,
                          child: const ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.close),
                            title: Text("Remove attachment"),
                          ),
                        ),
                        const PopupMenuItem(
                          value: AttachmentTryItemAction.addAltText,
                          enabled: false,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.drive_file_rename_outline_rounded,
                            ),
                            title: Text("Add alternate text"),
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum AttachmentTryItemAction { remove, addAltText }

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
