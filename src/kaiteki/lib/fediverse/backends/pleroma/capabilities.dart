import "package:kaiteki/fediverse/backends/mastodon/capabilities.dart";
import "package:kaiteki/fediverse/interfaces/reaction_support.dart";
import "package:kaiteki/fediverse/model/formatting.dart";

class PleromaCapabilities extends MastodonCapabilities
    implements ReactionSupportCapabilities {
  @override
  bool get supportsCustomEmojiReactions => false;

  @override
  bool get supportsUnicodeEmojiReactions => true;

  const PleromaCapabilities();

  @override
  Set<Formatting> get supportedFormattings {
    return const {
      Formatting.plainText,
      Formatting.html,
      Formatting.markdown,
      Formatting.bbCode,
    };
  }

  @override
  bool get supportsMultipleReactions => true;
}
