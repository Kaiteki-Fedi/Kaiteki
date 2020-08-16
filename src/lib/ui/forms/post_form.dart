import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/api/clients/mastodon_client.dart';
import 'package:kaiteki/api/clients/pleroma_client.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class PostForm extends StatefulWidget {
  const PostForm({
    Key key,
  }) : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountContainer>(context);
    var pleroma = container.client as PleromaClient;

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
                onPressed: () => post(pleroma),
              )
            ],
          )
        ],
      ),
    );
  }

  void post(MastodonClient client) async {
    await client.postStatus(bodyController.value.text);
  }
}