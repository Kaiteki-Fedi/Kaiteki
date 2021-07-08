import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/fediverse/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/fediverse/api/adapters/interfaces/preview_support.dart';
import 'package:kaiteki/fediverse/model/emoji_category.dart';
import 'package:kaiteki/fediverse/model/formatting.dart';
import 'package:kaiteki/fediverse/model/post_draft.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/visibility.dart' as v;
import 'package:kaiteki/ui/widgets/emoji/emoji_selector.dart';
import 'package:kaiteki/ui/widgets/formatting_button.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:kaiteki/ui/widgets/visibility_button.dart';
import 'package:kaiteki/utils/utils.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class PostForm extends StatefulWidget {
  final Post? replyTo;

  const PostForm({Key? key, this.replyTo}) : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  late TextEditingController _bodyController;
  late TextEditingController _subjectController;
  late RestartableTimer _typingTimer;
  var _isPreviewExpanded = false;
  var _visibility = v.Visibility.public;
  var _formatting = Formatting.plainText;
  final _attachMenuItems = [
    AttachMenuItem(
      label: "Attach files",
      icon: Mdi.file,
      onPressed: () {},
    ),
    AttachMenuItem(
      label: "Take picture",
      icon: Mdi.camera,
      onPressed: null,
    ),
    AttachMenuItem(
      label: "Create poll",
      icon: Mdi.pollBox,
      onPressed: null,
    ),
    AttachMenuItem(
      label: "Record voice",
      icon: Mdi.microphone,
      onPressed: null,
    ),
  ];

  _PostFormState() {
    _typingTimer = RestartableTimer(const Duration(seconds: 1), () {
      _typingTimer.cancel();
      setState(() {});
    });

    _bodyController = TextEditingController()..addListener(_typingTimer.reset);

    _subjectController = TextEditingController()
      ..addListener(_typingTimer.reset);
  }

  @override
  Widget build(BuildContext context) {
    var manager = Provider.of<AccountManager>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExpansionPanelList(
            expansionCallback: (_, v) {
              setState(() => _isPreviewExpanded = !v);
            },
            children: [
              ExpansionPanel(
                canTapOnHeader: true,
                isExpanded: _isPreviewExpanded,
                headerBuilder: (_, x) {
                  return const ListTile(title: Text("Preview"));
                },
                body: FutureBuilder(
                  future: getPreviewFuture(manager),
                  builder: buildPreview,
                ),
              ),
            ],
          ),
          TextField(
            decoration: const InputDecoration(hintText: "Subject (optional)"),
            controller: _subjectController,
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Just landed in L.A.",
              ),
              textAlignVertical: TextAlignVertical.top,
              expands: true,
              minLines: null,
              maxLines: null,
              controller: _bodyController,
            ),
          ),
          const Divider(),
          Row(
            children: [
              IconButton(
                onPressed: () => openAttachDrawer(),
                icon: const Icon(Mdi.plusCircle),
                splashRadius: 20,
                tooltip: "Attach",
              ),
              VisibilityButton(
                visibility: _visibility,
                callback: (value) => setState(() => _visibility = value),
              ),
              FormattingButton(
                formatting: _formatting,
                callback: (value) => setState(() => _formatting = value),
              ),
              IconButton(
                onPressed: () => openEmojiPicker(context, manager),
                icon: const Icon(Mdi.emoticon),
                splashRadius: 20,
                tooltip: "Insert emoji",
              ),
              const Spacer(),
              ElevatedButton(
                child: const Text("Submit"),
                onPressed: () => post(context, manager.adapter),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPreview(
    BuildContext context,
    AsyncSnapshot<Post<dynamic>> snapshot,
  ) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text('Start writing a post to see a preview!'),
          ),
        );

      case ConnectionState.done:
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: IconLandingWidget(Mdi.close, snapshot.error.toString()),
            ),
          );
        } else {
          return StatusWidget(snapshot.data!, showActions: false);
        }

      default:
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: CircularProgressIndicator()),
        );
    }
  }

  Future<Post>? getPreviewFuture(AccountManager manager) {
    if (_bodyController.value.text.isEmpty) return null;

    var previewAdapter = manager.adapter as PreviewSupport;
    return previewAdapter.getPreview(_getPostDraft());
  }

  PostDraft _getPostDraft() {
    return PostDraft(
      subject: _subjectController.value.text,
      content: _bodyController.value.text,
      visibility: _visibility,
      formatting: _formatting,
      replyTo: widget.replyTo,
    );
  }

  void post(BuildContext context, FediverseAdapter adapter) async {
    Navigator.of(context).pop();

    var messenger = ScaffoldMessenger.of(context);

    var theme = Theme.of(context);
    var snackBarTheme = theme.snackBarTheme;
    var invertedBrigthness = theme.brightness == Brightness.light
        ? Brightness.dark
        : Brightness.light;
    var fallbackTextStyle =
        ThemeData(brightness: invertedBrigthness).textTheme.subtitle1;
    var snackBarTextStyle = snackBarTheme.contentTextStyle ?? fallbackTextStyle;

    var snackBar = Utils.generateAsyncSnackBar(
      context: context,
      done: false,
      text: const Text("Sending post..."),
      icon: const Icon(Mdi.textBox),
      foreColor: snackBarTextStyle?.color,
    );

    messenger.showSnackBar(snackBar);

    //await Future.delayed(const Duration(seconds: 10), () {});

    /*var post =*/ await adapter.postStatus(_getPostDraft());

    messenger.removeCurrentSnackBar();

    snackBar = Utils.generateAsyncSnackBar(
      context: context,
      done: true,
      text: const Text("Post sent"),
      icon: const Icon(Mdi.check),
      foreColor: snackBarTextStyle?.color,
      // action: SnackBarAction(
      //   label: 'View post'.toUpperCase(),
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(
      //       builder: (_) => ConversationScreen(post),
      //     ));
      //   },
      // ),
    );

    messenger.showSnackBar(snackBar);
  }

  void openEmojiPicker(BuildContext context, AccountManager container) {
    Scaffold.of(context).showBottomSheet(
      (context) {
        return Material(
          type: MaterialType.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6.0)),
          child: SizedBox(
            height: 250,
            child: FutureBuilder(
              future: container.adapter.getEmojis(),
              builder: buildEmojiSelector,
            ),
          ),
        );
      },
    );
  }

  Widget buildEmojiSelector(c, AsyncSnapshot<Iterable<EmojiCategory>> s) {
    if (s.hasError) {
      return const Center(child: Text("Failed to fetch emojis."));
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
    Scaffold.of(context).showBottomSheet(
      (context) {
        return LayoutBuilder(
          builder: (context, data) {
            final columns = max((data.maxWidth ~/ 300) * 2, 2);
            final itemWidth = data.maxWidth / columns;
            final itemAspectRatio = itemWidth / 96;

            return BottomSheet(
              elevation: 24,
              builder: (BuildContext context) {
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
                        onPressed: item.onPressed,
                      ),
                  ],
                );
              },
              onClosing: () {},
            );
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
