import "package:kaiteki/fediverse/backends/mastodon/capabilities.dart";
import "package:kaiteki/fediverse/interfaces/reaction_support.dart";
import "package:kaiteki/fediverse/model/formatting.dart";

class GlitchCapabilities extends MastodonCapabilities
    implements ReactionSupportCapabilities {
  const GlitchCapabilities();

  @override
  Set<Formatting> get supportedFormattings {
    return const {
      Formatting.plainText,
      Formatting.markdown,
    };
  }

  // TODO(erincandescent): Detect per-instance support for these
  @override
  bool get supportsCustomEmojiReactions => false;
  @override
  bool get supportsUnicodeEmojiReactions => true;
  @override
  bool get supportsMultipleReactions => true;
}
