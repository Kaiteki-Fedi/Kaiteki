import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/backends/misskey/adapter.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/text/text_renderer.dart";
import "package:logging/logging.dart";

extension PostRenderExtensions on Post {
  InlineSpan renderContent(
    BuildContext context,
    WidgetRef ref, {
    bool showReplyees = true,
  }) {
    final replyee = replyToUser?.data;

    assert(content != null);
    final elements = parseText(content!, ref.read(textParserProvider));
    final renderer = TextRenderer.fromContext(
      context,
      ref,
      TextContext(
        emojiResolver: (e) => resolveEmoji(e, ref, author.host, emojis),
        users: mentionedUsers ?? [],
        excludedUsers: [
          if (!showReplyees && replyee != null)
            UserReference.handle(replyee.username, replyee.host)
        ],
      ),
    );
    return renderer.render(elements);
  }
}

extension ChatMessageRenderExtensions on ChatMessage {
  InlineSpan renderContent(BuildContext context, WidgetRef ref) {
    assert(content != null);
    final elements = parseText(content!, ref.read(textParserProvider));
    final renderer = TextRenderer.fromContext(context, ref);
    return renderer.render(elements);
  }
}

extension UserRenderExtensions on User {
  InlineSpan renderDisplayName(BuildContext context, WidgetRef ref) {
    final displayName = this.displayName;
    if (displayName == null || displayName.isEmpty) {
      return TextSpan(text: username);
    }
    return renderText(context, ref, displayName);
  }

  InlineSpan renderDescription(BuildContext context, WidgetRef ref) {
    final hasDescription = description != null;
    assert(hasDescription);
    if (!hasDescription) return const TextSpan(text: "");
    return renderText(context, ref, description!);
  }

  InlineSpan renderText(BuildContext context, WidgetRef ref, String text) {
    final elements = parseText(text, ref.read(textParserProvider));
    final renderer = TextRenderer.fromContext(
      context,
      ref,
      TextContext(emojiResolver: (e) => resolveEmoji(e, ref, host, emojis)),
    );
    return renderer.render(elements);
  }
}

Emoji? resolveEmoji(
  String input,
  WidgetRef ref, [
  String? remoteHost,
  List<Emoji>? emojis,
]) {
  final logger = Logger("resolveEmoji");
  final adapter = ref.read(adapterProvider);

  if (emojis != null) {
    final emoji = emojis.firstWhereOrNull((e) => e.short == input);

    if (emoji == null) {
      logger.warning("Couldn't find $input in provided emojis");
    }

    return emoji;
  }

  logger.fine("No emojis were provided");

  if (adapter is MisskeyAdapter) {
    final url = buildEmojiUriManual(adapter.instance, input, remoteHost);
    logger.fine("Returning mkv13 emoji based on static url: $url");
    return CustomEmoji(
      short: input,
      url: url,
      instance: remoteHost ?? adapter.instance,
    );
  }

  logger.fine("Couldn't resolve emoji $input");

  return null;
}
