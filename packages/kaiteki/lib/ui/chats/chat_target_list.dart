import "package:flutter/material.dart";
import "package:kaiteki/l10n/localizations.dart";
import "package:kaiteki/ui/chats/chat_target_tile.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki_core/kaiteki_core.dart";

class ChatTargetList extends StatelessWidget {
  const ChatTargetList({
    super.key,
    required this.chats,
    this.onChatSelected,
    this.selectedChatId,
  });

  final ChatSelectedCallback? onChatSelected;
  final String? selectedChatId;
  final List<ChatTarget> chats;

  @override
  Widget build(BuildContext context) {
    return chats.isEmpty ? _Placeholder() : _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ChatTargetTile(
            chat: chat,
            onChatSelected: onChatSelected,
            selected: chat.id == selectedChatId,
          );
        },
        itemCount: chats.length,
        // TODO(Craftplacer): HACK: should be exposed instead
        padding: const EdgeInsets.only(
          bottom: (kFloatingActionButtonMargin * 2) + 52,
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconLandingWidget(
        icon: const Icon(Icons.message_rounded),
        text: Text(KaitekiLocalizations.of(context)!.empty),
      ),
    );
  }
}
