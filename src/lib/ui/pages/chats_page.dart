import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/adapters/interfaces/chat_support.dart';
import 'package:kaiteki/model/fediverse/chat.dart';
import 'package:kaiteki/ui/screens/chat_screen.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage({Key key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
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

    return FutureBuilder(
      future: chatAdapter.getChats(),
      builder: (_, AsyncSnapshot<Iterable<Chat>> snapshot) {
        if (snapshot.hasData)
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, i) {
              var chat = snapshot.data.elementAt(i);
              return ListTile(
                  // leading: AvatarWidget(chat.recipient, size: 48),
                  title: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text(chat.recipient.displayName),
                      // Text("69d")
                    ],
                  ),
                  subtitle: chat.lastMessage == null ? null : Text(chat.lastMessage.content.content),
                  onTap: () {
                    var chatScreen = ChatScreen(chat);
                    var route = MaterialPageRoute(builder: (_) => chatScreen);
                    Navigator.push(context, route);
                  }
              );
            },
          );

        if (snapshot.hasError)
          return Center(child: IconLandingWidget(icon: Mdi.close, text: snapshot.error.toString()));

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}