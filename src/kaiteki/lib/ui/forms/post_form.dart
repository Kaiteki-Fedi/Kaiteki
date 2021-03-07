import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/fediverse/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/fediverse/model/formatting.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/widgets/emoji/emoji_selector.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class PostForm extends StatefulWidget {
  final Post replyTo;

  const PostForm({Key key, this.replyTo}) : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountContainer>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("Preview"),
              IconButton(
                icon: Icon(Mdi.chevronRight),
                onPressed: null,
              ),
            ],
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Subject (optional)",
            ),
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
              controller: bodyController,
            ),
          ),
          Row(
            children: [
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Mdi.earth),
              //   splashRadius: 20,
              // ),
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
                onPressed: () => openEmojiPicker(context, container),
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
                onPressed: () => post(container.adapter),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void post(FediverseAdapter adapter) async {
    await adapter.postStatus(
      Post(
        content: bodyController.value.text,
        formatting: Formatting.PlainText,
      ),
      parentPost: widget.replyTo,
    );
  }

  void openEmojiPicker(BuildContext context, AccountContainer container) {
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
              builder: (c, s) {
                if (s.hasError) {
                  print(s.error);
                  return Center(child: Text("Failed to fetch emojis."));
                }

                if (!s.hasData)
                  return Center(child: CircularProgressIndicator());

                return EmojiSelector(
                  categories: s.data,
                  onEmojiSelected: (emoji) {
                    bodyController.text =
                        bodyController.text += emoji.toString();
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
