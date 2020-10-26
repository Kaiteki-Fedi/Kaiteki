import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/model/fediverse/formatting.dart';
import 'package:kaiteki/model/fediverse/post.dart';
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
              )
            ],
          ),
          TextField(
            decoration: InputDecoration(
                hintText: "Subject (optional)"
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
              IconButton(
                onPressed: () {},
                icon: Icon(Mdi.earth),
                splashRadius: 20,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Mdi.languageMarkdownOutline),
                splashRadius: 20,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Mdi.upload),
                splashRadius: 20,
                tooltip: "Attach files",
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Mdi.emoticon),
                splashRadius: 20,
                tooltip: "Insert emoji",
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Mdi.sticker),
                splashRadius: 20,
                tooltip: "Add sticker",
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Mdi.pollBox),
                splashRadius: 20,
                tooltip: "Add poll",
              ),

              Spacer(),
              RaisedButton(
                child: Text("Submit"),
                onPressed: () => post(container.adapter),
              )
            ],
          )
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
}