import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/api/clients/pleroma_client.dart';
import 'package:kaiteki/api/model/pleroma/pleroma_chat.dart';
import 'package:kaiteki/ui/screens/chat_screen.dart';
import 'package:kaiteki/ui/widgets/avatar_widget.dart';
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

    if (!container.loggedIn)
      return Center(
        child: IconLandingWidget(
          Mdi.key,
          "You need to be signed in to use chats"
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

    return FutureBuilder(
      future: pleroma.getChats(),
      builder: (_, AsyncSnapshot<Iterable<PleromaChat>> snapshot) {
        if (snapshot.hasData)
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, i) {
              var chat = snapshot.data.elementAt(i);
              return ListTile(
                  leading: AvatarWidget(chat.account, size: 48),
                  title: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(chat.account.displayName),
                      // Text("69d")
                    ],
                  ),
                  subtitle: chat.lastMessage == null ? null : Text(chat.lastMessage.content),
                  onTap: () {
                    var chatScreen = ChatScreen(chat);
                    var route = MaterialPageRoute(builder: (_) => chatScreen);
                    Navigator.push(context, route);
                  }
              );
            },
          );

        if (snapshot.hasError)
          return Center(child: IconLandingWidget(Mdi.close, snapshot.error.toString()));

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}