import 'package:fediverse_objects/mastodon_v1.dart';
import 'package:kaiteki_core/backends/mastodon.dart';
import 'package:kaiteki_core/src/social/backends/mastodon/extensions.dart';
import 'package:kaiteki_core/social.dart' hide Instance;

class PleromaCapabilities extends MastodonCapabilities
    implements ReactionSupportCapabilities, ChatSupportCapabilities {
  @override
  final bool supportsCustomEmojiReactions;

  @override
  bool get supportsUnicodeEmojiReactions => true;

  const PleromaCapabilities({
    required this.supportedFormattings,
    required this.maxPostContentLength,
    required this.supportsChat,
    required this.supportsCustomEmojiReactions,
  });

  @override
  final Set<Formatting> supportedFormattings;

  @override
  bool get supportsMultipleReactions => true;

  @override
  final int? maxPostContentLength;

  @override
  final bool supportsChat;

  factory PleromaCapabilities.fromInstance(Instance instance) {
    // instanceInfo.pleroma.metadata.
    final metadata = instance.pleroma!.metadata;
    return PleromaCapabilities(
      maxPostContentLength: instance.maxTootChars,
      supportedFormattings:
          metadata.postFormats.map(pleromaFormattingRosetta.getRight).toSet(),
      supportsChat: metadata.features.contains('pleroma_chat_messages'),
      supportsCustomEmojiReactions:
          metadata.features.contains('custom_emoji_reactions'),
    );
  }
}
