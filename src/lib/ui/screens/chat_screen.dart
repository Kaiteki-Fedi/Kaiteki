import 'package:flutter/material.dart';
import 'package:kaiteki/TextRenderer.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/api/clients/pleroma_client.dart';
import 'package:kaiteki/api/model/pleroma/pleroma_chat.dart';
import 'package:kaiteki/api/model/pleroma/pleroma_chat_message.dart';
import 'package:kaiteki/ui/widgets/avatar_widget.dart';
import 'package:kaiteki/ui/widgets/chat_message_widget.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(this.chat, {Key key}) : super(key: key);

  final PleromaChat chat;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountContainer>(context);

    if (!container.loggedIn)
      return Center(
        child: IconLandingWidget(
          Mdi.key,
          "You need to be signed in, to use Chats"
        )
      );

    if (!(container.client is PleromaClient))
      return Center(
        child: IconLandingWidget(
          Mdi.emoticonFrown,
          "Unsupported client"
        )
      );

    var pleroma = container.client as PleromaClient;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AvatarWidget(widget.chat.account, size: 32),
            ),
            RichText(
              text: TextRenderer(emojis: widget.chat.account.emojis)
                  .render(widget.chat.account.displayName),
            ),
          ],
        )
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: pleroma.getChatMessages(widget.chat.id),
              builder: (_, AsyncSnapshot<Iterable<PleromaChatMessage>> snapshot) {
                if (snapshot.hasError)
                  return Center(child: IconLandingWidget(Mdi.close, snapshot.error.toString()));

                if (snapshot.hasData)
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    padding: EdgeInsets.all(8),

                    itemBuilder: (_, i) {
                      var message = snapshot.data.elementAt(i);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChatMessageWidget(widget.chat, message),
                      );
                    },
                  );

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Divider(
            height: 2
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Message ${widget.chat.account.username}"
                    ),
                    keyboardType: TextInputType.text,

                    onSubmitted: (message) async {
                      await pleroma.postChatMessage(widget.chat.id, message);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Mdi.send),
                  onPressed: null,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}