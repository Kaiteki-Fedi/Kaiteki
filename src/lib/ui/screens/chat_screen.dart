import 'package:flutter/material.dart';
import 'package:kaiteki/api/adapters/interfaces/chat_support.dart';
import 'package:kaiteki/model/fediverse/chat.dart';
import 'package:kaiteki/model/fediverse/chat_message.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/ui/widgets/chat_message_widget.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(this.chat, {Key key}) : super(key: key);

  final Chat chat;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountContainer>(context);
    var chatAdapter = container.adapter as ChatSupport;

    if (!container.loggedIn)
      return Center(
        child: IconLandingWidget(
          icon: Mdi.key,
          text: "You need to be signed in to use chats"
        )
      );

    return Scaffold(
      appBar: AppBar(
        // TODO: Fix title for chat recipients
        title: Text("Chat")
        //Row(
        //  children: [
        //    Padding(
        //      padding: const EdgeInsets.only(right: 8),
        //      child: AvatarWidget(widget.chat.recipient, size: 32),
        //    ),
        //    RichText(
        //      text: TextRenderer(emojis: null) // widget.chat.recipient.emojis
        //          .render(widget.chat.account.displayName),
        //    ),
        //  ],
        //)
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: chatAdapter.getChatMessages(widget.chat),
              builder: (_, AsyncSnapshot<Iterable<ChatMessage>> snapshot) {
                if (snapshot.hasError)
                  return Center(
                    child: IconLandingWidget(
                      icon: Mdi.close,
                      text: snapshot.error.toString()
                    )
                  );

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
                    //decoration: InputDecoration(
                    //  hintText: "Message ${widget.chat.account.username}"
                    //),
                    keyboardType: TextInputType.text,
                    onSubmitted: (message) async {
                      await chatAdapter.postChatMessage(widget.chat, ChatMessage(content: Post(content: message)));
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