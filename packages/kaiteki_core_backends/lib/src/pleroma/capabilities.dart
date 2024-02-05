import 'package:fediverse_objects/mastodon_v1.dart' show Instance;
import 'package:kaiteki_core/social.dart' hide Instance;
import 'package:kaiteki_core_backends/mastodon.dart';

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
