import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/chat_support.dart';
import 'package:kaiteki/fediverse/model/chat_message.dart';
import 'package:kaiteki/fediverse/model/chat_target.dart';
import 'package:kaiteki/ui/dialogs/search_user_dialog.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';
import 'package:kaiteki/ui/widgets/chats/chat_message.dart';
import 'package:kaiteki/ui/widgets/chats/chat_target_list.dart';
import 'package:kaiteki/ui/widgets/chats/compose_message_bar.dart';
import 'package:mdi/mdi.dart';

class ChatsPage extends ConsumerStatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends ConsumerState<ChatsPage> {
  ChatTarget? selectedChat;
  bool _readNotice = false;

  @override
  Widget build(BuildContext context) {
    final adapter = ref.read(adapterProvider) as ChatSupport;

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
                child: FutureBuilder<Iterable<ChatTarget>>(
                  future: adapter.getChats(),
                  builder: (
                    context,
                    snapshot,
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
                                builder: (_) => const SearchUserDialog(),
                              );
                            },
                            tooltip: "Start a new chat",
                            child: const Icon(Mdi.plus),
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
                  key: ValueKey(selectedChat?.id),
                ),
        ),
      ],
    );
  }
}

class ChatView extends ConsumerWidget {
  const ChatView({
    Key? key,
    required this.chat,
  }) : super(key: key);

  final ChatTarget chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.read(accountProvider);
    final adapter = manager.adapter as ChatSupport;
    final currentAccount = manager.currentAccount.account;

    return Column(
      children: [
        Row(
          children: [
            const Text("Chat recipient"),
            const Spacer(),
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
          child: FutureBuilder<Iterable<ChatMessage>>(
            future: adapter.getChatMessages(chat),
            builder: (context, snapshot) {
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
          onSendMessage: (content, attachments) {},
        ),
      ],
    );
  }
}
