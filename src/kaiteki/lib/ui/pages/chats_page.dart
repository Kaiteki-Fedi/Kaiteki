import 'package:flutter/material.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/fediverse/api/adapters/interfaces/chat_support.dart';
import 'package:kaiteki/fediverse/model/chat_message.dart';
import 'package:kaiteki/fediverse/model/chat_target.dart';
import 'package:kaiteki/ui/dialogs/search_user_dialog.dart';
import 'package:kaiteki/ui/widgets/chats/chat_message.dart';
import 'package:kaiteki/ui/widgets/chats/chat_target_list.dart';
import 'package:kaiteki/ui/widgets/chats/compose_message_bar.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  ChatTarget? selectedChat;
  bool _readNotice = false;

  @override
  Widget build(BuildContext context) {
    final manager = context.read<AccountManager>();
    final adapter = manager.adapter as ChatSupport;

    return Row(
      children: [
        SizedBox(
          width: 350,
          child: Column(
            children: [
              if (!_readNotice)
                MaterialBanner(
                  content: const ListTile(
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: 12,
                    leading: CircleAvatar(
                      backgroundColor: Colors.yellow,
                      child: Icon(
                        Mdi.alertOctagon,
                        color: Colors.black,
                      ),
                    ),
                    title: Text("Chats are currently in development"),
                    subtitle: Text("Not all UI elements may work."),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => setState(() => _readNotice = true),
                      child: const Text("Got it"),
                    ),
                  ],
                ),
              Expanded(
                child: FutureBuilder(
                  future: adapter.getChats(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<Iterable<ChatTarget>> snapshot,
                  ) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final chats = snapshot.data!;

                    return Stack(
                      children: [
                        ChatTargetList(
                          chats: chats.toList(growable: false),
                          onChatSelected: (chat) {
                            setState(() => selectedChat = chat);
                          },
                          selectedChatId: selectedChat?.id,
                        ),
                        Positioned(
                          right: kFloatingActionButtonMargin,
                          bottom: kFloatingActionButtonMargin,
                          child: FloatingActionButton(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (_) => SearchUserDialog(),
                              );
                            },
                            child: const Icon(Mdi.plus),
                            tooltip: "Start a new chat",
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        VerticalDivider(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
        Expanded(
          child: selectedChat == null
              ? const Center(
                  child: IconLandingWidget(
                    icon: Icon(Mdi.forumOutline),
                    text: Text("Select a chat to begin"),
                  ),
                )
              : ChatView(
                  chat: selectedChat!,
                  key: ValueKey(selectedChat?.id.toString()),
                ),
        ),
      ],
    );
  }
}

class ChatView extends StatelessWidget {
  const ChatView({
    Key? key,
    required this.chat,
  }) : super(key: key);

  final ChatTarget chat;

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<AccountManager>();
    final adapter = manager.adapter as ChatSupport;
    final currentAccount = manager.currentAccount.account;

    return Column(
      children: [
        Row(
          children: [
            Text("Chat recipient"),
            Spacer(),
            PopupMenuButton(
              itemBuilder: (context) {
                return List.generate(5, (index) {
                  return PopupMenuItem(
                    value: index,
                    child: Text('button no $index'),
                  );
                });
              },
            )
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: FutureBuilder(
            future: adapter.getChatMessages(chat),
            builder: (context, AsyncSnapshot<Iterable<ChatMessage>> snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final messages = snapshot.data!;

              if (messages.isEmpty) {
                return const Center(
                  child: IconLandingWidget(
                    icon: Icon(Mdi.messageOutline),
                    text: Text("Looks empty here..."),
                  ),
                );
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  final item = messages.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChatMessageWidget(
                      message: item,
                      received: currentAccount.id != item.author.id,
                    ),
                  );
                },
                itemCount: messages.length,
                reverse: true,
              );
            },
          ),
        ),
        const Divider(height: 1),
        ComposeMessageBar(
          onSendMessage: (String content, List<dynamic> attachments) {},
        ),
      ],
    );
  }
}
