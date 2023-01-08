import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/chat_support.dart';
import 'package:kaiteki/fediverse/model/chat_message.dart';
import 'package:kaiteki/fediverse/model/chat_target.dart';
import 'package:kaiteki/preferences/app_experiment.dart';
import 'package:kaiteki/ui/chats/chat_message.dart';
import 'package:kaiteki/ui/chats/chat_target_list.dart';
import 'package:kaiteki/ui/chats/compose_message_bar.dart';
import 'package:kaiteki/ui/shared/dialogs/find_user_dialog.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:mdi/mdi.dart';

class ChatsPage extends ConsumerStatefulWidget {
  const ChatsPage({super.key});

  @override
  ConsumerState<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends ConsumerState<ChatsPage> {
  ChatTarget? selectedChat;

  @override
  Widget build(BuildContext context) {
    final adapter = ref.read(adapterProvider) as ChatSupport;

    if (!ref
        .watch(preferencesProvider.select((value) => value.enabledExperiments))
        .contains(AppExperiment.chats)) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const IconLandingWidget(
              icon: Icon(Icons.science_rounded),
              text: Text("Chats are experimental"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .read(preferencesProvider)
                  .enableExperiment(AppExperiment.chats),
              child: const Text("Enable Experiment"),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        SizedBox(
          width: 350,
          child: Column(
            children: [
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
                                builder: (_) => const FindUserDialog(),
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
    super.key,
    required this.chat,
  });

  final ChatTarget chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adapter = ref.watch(adapterProvider) as ChatSupport;
    final currentUser = ref.watch(accountProvider)?.user;

    return Column(
      children: [
        ListTile(
          leading: _buildIcon(context, ref),
          title: _buildTitle(context, ref),
          trailing: PopupMenuButton(
            itemBuilder: (context) {
              return List.generate(5, (index) {
                return PopupMenuItem(
                  value: index,
                  child: Text('button no $index'),
                );
              });
            },
          ),
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
                      received: currentUser?.id != item.author.id,
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

  Widget _buildTitle(BuildContext context, WidgetRef ref) {
    final chat = this.chat;
    if (chat is DirectChat) {
      return Text.rich(chat.recipient.renderDisplayName(context, ref));
    }
    if (chat is GroupChat) {
      return Text(chat.name ?? chat.fallbackName);
    }

    return Text(chat.toString());
  }

  Widget? _buildIcon(BuildContext context, WidgetRef ref) {
    final chat = this.chat;
    if (chat is DirectChat) {
      return AvatarWidget(chat.recipient, size: 32);
    }
    return null;
  }
}
