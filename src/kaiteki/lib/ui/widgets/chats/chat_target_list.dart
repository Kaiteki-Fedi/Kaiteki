import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/fediverse/model/chat_target.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';
import 'package:kaiteki/ui/widgets/chats/chat_target_tile.dart';
import 'package:mdi/mdi.dart';

class ChatTargetList extends StatelessWidget {
  const ChatTargetList({
    Key? key,
    required this.chats,
    this.onChatSelected,
    this.selectedChatId,
  }) : super(key: key);

  final ChatSelectedCallback? onChatSelected;
  final String? selectedChatId;
  final List<ChatTarget> chats;

  @override
  Widget build(BuildContext context) {
    return chats.isEmpty ? _Placeholder() : _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
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
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconLandingWidget(
        icon: const Icon(Mdi.messageOutline),
        text: Text(AppLocalizations.of(context)!.empty),
      ),
    );
  }
}
