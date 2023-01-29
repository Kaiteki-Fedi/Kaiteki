import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/chat_target.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/helpers.dart";
import "package:kaiteki/utils/text/text_renderer.dart";
import "package:mdi/mdi.dart";

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
      selectedColor: theme.colorScheme.onSecondaryContainer,
      selectedTileColor: theme.colorScheme.secondaryContainer,
      child: ListTile(
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
      final renderedContent = render(
        context,
        content,
        textContext: TextContext(
          emojiResolver: (e) => resolveEmoji(e, ref, lastMessage.emojis),
        ),
        textTheme: Theme.of(context).ktkTextTheme!,
        onUserClick: (reference) => resolveAndOpenUser(reference, context, ref),
        parsers: ref.read(textParserProvider),
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
    if (!chat.unread) return null;

    return const Badge();
  }

  InlineSpan _getChatTitle(
    BuildContext context,
    WidgetRef ref,
    ChatTarget chat,
  ) {
    if (chat is DirectChat) {
      return chat.recipient.renderDisplayName(context, ref);
    } else if (chat is GroupChat) {
      return TextSpan(text: chat.name);
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
