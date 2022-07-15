import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/chat_target.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/helpers.dart';
import 'package:kaiteki/utils/text/text_renderer.dart';
import 'package:mdi/mdi.dart';

typedef ChatSelectedCallback = void Function(ChatTarget chat);

class ChatTargetTile extends ConsumerWidget {
  const ChatTargetTile({
    super.key,
    required this.chat,
    this.selected = false,
    this.onChatSelected,
  });

  final ChatTarget chat;
  final bool selected;
  final ChatSelectedCallback? onChatSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListTileTheme(
      selectedColor: theme.colorScheme.onPrimary,
      selectedTileColor: theme.colorScheme.primary,
      child: ListTile(
        tileColor: Colors.green,
        selectedTileColor: Colors.red,
        selected: selected,
        leading: _buildChatTargetAvatar(chat),
        title: Text.rich(_getChatTitle(context, ref, chat)),
        subtitle: _buildPreview(context, ref),
        trailing: _buildBadge(context),
        onTap: () => onChatSelected?.call(chat),
      ),
    );
  }

  Widget? _buildPreview(BuildContext context, WidgetRef ref) {
    final lastMessage = chat.lastMessage;

    if (lastMessage == null) {
      return Container();
    }

    final content = lastMessage.content;
    if (content != null) {
      final renderedContent = const TextRenderer().render(
        context,
        content,
        textContext: TextContext(
          users: [],
          emojis: lastMessage.emojis.toList(growable: false),
        ),
        onUserClick: (reference) => resolveAndOpenUser(reference, context, ref),
      );

      return Text.rich(
        renderedContent,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final attachments = lastMessage.attachments;
    if (attachments.isNotEmpty) {
      return Row(
        children: [
          const Icon(Mdi.attachment, size: 12.0),
          const SizedBox(width: 6.0),
          Text(
            "${attachments.length} attachment(s)",
            style: const TextStyle(fontStyle: FontStyle.italic),
          )
        ],
      );
    }

    return null;
  }

  Widget? _buildBadge(BuildContext context) {
    if (chat.unreadMessages < 1) {
      return null;
    }

    final theme = Theme.of(context);
    return Badge(
      badgeContent: Text(
        chat.unreadMessages.toString(),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12.0,
          color: theme.colorScheme.onSecondary,
        ),
      ),
      badgeColor: theme.colorScheme.secondary,
      padding: const EdgeInsets.all(6.0),
      elevation: 0,
      toAnimate: false,
    );
  }

  InlineSpan _getChatTitle(
      BuildContext context, WidgetRef ref, ChatTarget chat) {
    if (chat is DirectChat) {
      return chat.recipient.renderDisplayName(context, ref);
    } else if (chat is GroupChat) {
      // TODO(Craftplacer): Display chat group title
      return const TextSpan(text: "Group Title");
    } else {
      throw UnimplementedError();
    }
  }

  Widget _buildChatTargetAvatar(ChatTarget chat) {
    if (chat is DirectChat) {
      return AvatarWidget(chat.recipient, size: 40);
    } else if (chat is GroupChat) {
      return const CircleAvatar(child: Icon(Mdi.accountMultiple));
    } else {
      throw UnimplementedError();
    }
  }
}
