import 'package:flutter/material.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/fediverse/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/fediverse/api/adapters/interfaces/preview_support.dart';
import 'package:kaiteki/fediverse/model/emoji_category.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/post_draft.dart';
import 'package:kaiteki/fediverse/model/visibility.dart' as v;
import 'package:kaiteki/ui/screens/conversation_screen.dart';
import 'package:kaiteki/ui/widgets/emoji/emoji_selector.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:kaiteki/ui/widgets/visibility_button.dart';
import 'package:kaiteki/utils/utils.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

class PostForm extends StatefulWidget {
  final Post? replyTo;

  const PostForm({Key? key, this.replyTo}) : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  late TextEditingController _bodyController;
  late TextEditingController _subjectController;
  bool _isPreviewExpanded = false;
  v.Visibility _visibility = v.Visibility.Public;
  late RestartableTimer _typingTimer;

  _PostFormState() {
    _typingTimer = RestartableTimer(Duration(seconds: 1), () {
      _typingTimer.cancel();
      setState((){});
    });

    _bodyController = TextEditingController()
      ..addListener(_typingTimer.reset);

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
            expansionCallback: (_, v) => setState(() => _isPreviewExpanded = !v),
            children: [
              ExpansionPanel(
                canTapOnHeader: true,
                isExpanded: _isPreviewExpanded,
                headerBuilder: (_, x) {
                  return ListTile(title: Text("Preview"));
                },
                body: FutureBuilder(
                  future: getPreviewFuture(manager),
                  builder: (BuildContext context, AsyncSnapshot<Post<dynamic>> snapshot) {
                    if (snapshot.hasError) {

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: IconLandingWidget(
                            Mdi.close,
                            snapshot.error.toString(),
                          ),
                        ),
                      );
                    }

                    if (_bodyController.value.text.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: const Text('Start writing a post to see a preview!')),
                      );

                    }

                    if (!snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return StatusWidget(snapshot.data!, showActions: false);
                  },
                )
              ),
            ],
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Subject (optional)",
            ),
            controller: _subjectController,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Just landed in L.A.",
              ),
              textAlignVertical: TextAlignVertical.top,
              enableSuggestions: true,
              expands: true,
              minLines: null,
              maxLines: null,
              maxLength: 60000,
              controller: _bodyController,
            ),
          ),
          Row(
            children: [
              VisibilityButton(
                visibility: _visibility,
                callback: (value) => setState(() => _visibility = value),
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Mdi.languageMarkdownOutline),
              //   splashRadius: 20,
              // ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Mdi.upload),
              //   splashRadius: 20,
              //   tooltip: "Attach files",
              // ),
              IconButton(
                onPressed: () => openEmojiPicker(context, manager),
                icon: Icon(Mdi.emoticon),
                splashRadius: 20,
                tooltip: "Insert emoji",
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Mdi.sticker),
              //   splashRadius: 20,
              //   tooltip: "Add sticker",
              // ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Mdi.pollBox),
              //   splashRadius: 20,
              //   tooltip: "Add poll",
              // ),

              Spacer(),

              ElevatedButton(
                child: Text("Submit"),
                onPressed: () => post(context, manager.adapter),
              ),
            ],
          ),
        ],
      ),
    );
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
    );
  }

  void post(BuildContext context, FediverseAdapter adapter) async {
    Navigator.of(context).pop();

    var messenger = ScaffoldMessenger.of(context);

    var snackBar = Utils.generateAsyncSnackBar(
      done: false,
      text: Text("Sending post..."),
      icon: Icon(Mdi.textBox),
    );

    messenger.showSnackBar(snackBar);

    //await Future.delayed(Duration(seconds: 3), () {
    //  print("This code executes after 5 seconds");
    //});

    var post = await adapter.postStatus(_getPostDraft());

    messenger.removeCurrentSnackBar();

    snackBar = Utils.generateAsyncSnackBar(
      done: true,
      text: Text("Post sent"),
      icon: Icon(Mdi.check),
      action: SnackBarAction(
        label: 'View post'.toUpperCase(),
        onPressed: () {
         //Navigator.of(context).push(MaterialPageRoute(
         //  builder: (_) => ConversationScreen(post),
         //));
        },
      ),
    );

    messenger.showSnackBar(snackBar);
  }

  void openEmojiPicker(BuildContext context, AccountManager container) {
    Scaffold.of(context).showBottomSheet(
      (context) {
        return Material(
          type: MaterialType.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(6.0),
          ),
          child: SizedBox(
            height: 250,
            child: FutureBuilder(
              future: container.adapter.getEmojis(),
              builder: (c, AsyncSnapshot<Iterable<EmojiCategory>> s) {
                if (s.hasError) {
                  print(s.error);
                  return Center(child: Text("Failed to fetch emojis."));
                }

                if (!s.hasData)
                  return Center(child: CircularProgressIndicator());

                return EmojiSelector(
                  categories: s.data!,
                  onEmojiSelected: (emoji) {
                    _bodyController.text =
                        _bodyController.text += emoji.toString();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
