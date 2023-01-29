import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/backends/misskey/adapter.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/utils/helpers.dart";
import "package:kaiteki/utils/text/text_renderer.dart";

Emoji? resolveEmoji(String input, WidgetRef ref, [List<Emoji>? emojis]) {
  final adapter = ref.read(adapterProvider);

  if (emojis != null) {
    return emojis.firstWhereOrNull((e) => e.short == input);
  }

  if (adapter is MisskeyAdapter) {
    final url = buildEmojiUri(adapter.instance, input);
    return CustomEmoji(short: input, url: url);
  }

  return null;
}

extension PostRenderExtensions on Post {
  InlineSpan renderContent(
    BuildContext context,
    WidgetRef ref, {
    bool hideReplyee = false,
  }) {
    final replyee = replyToUser?.data;

    return render(
      parsers: ref.read(textParserProvider),
      context,
      content!,
      textContext: TextContext(
        emojiResolver: (e) => resolveEmoji(e, ref, emojis),
        users: mentionedUsers,
        excludedUsers: [
          if (hideReplyee && replyee != null)
            UserReference.handle(replyee.username, replyee.host)
        ],
      ),
      onUserClick: (reference) => resolveAndOpenUser(reference, context, ref),
      textTheme: Theme.of(context).ktkTextTheme!,
    );
  }
}

extension ChatMessageRenderExtensions on ChatMessage {
  InlineSpan renderContent(BuildContext context, WidgetRef ref) {
    return render(
      parsers: ref.read(textParserProvider),
      context,
      content!,
      textContext: TextContext(
        emojiResolver: (e) => resolveEmoji(e, ref, emojis),
      ),
      onUserClick: (reference) => resolveAndOpenUser(reference, context, ref),
      textTheme: Theme.of(context).ktkTextTheme!,
    );
  }
}

extension UserRenderExtensions on User {
  InlineSpan renderDisplayName(BuildContext context, WidgetRef ref) {
    return renderText(context, ref, displayName!);
  }

  InlineSpan renderDescription(BuildContext context, WidgetRef ref) {
    return renderText(context, ref, description!);
  }

  InlineSpan renderText(BuildContext context, WidgetRef ref, String text) {
    return render(
      parsers: ref.read(textParserProvider),
      context,
      text,
      textContext: TextContext(
        users: [],
        emojiResolver: (e) => resolveEmoji(e, ref, emojis),
      ),
      onUserClick: (reference) => resolveAndOpenUser(reference, context, ref),
      textTheme: Theme.of(context).ktkTextTheme!,
    );
  }
}
