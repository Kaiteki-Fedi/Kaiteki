import "package:kaiteki/fediverse/backends/mastodon/capabilities.dart";
import "package:kaiteki/fediverse/interfaces/reaction_support.dart";
import "package:kaiteki/fediverse/model/formatting.dart";

class GlitchCapabilities extends MastodonCapabilities
    implements ReactionSupportCapabilities {
  const GlitchCapabilities();

  // TODO(erincandescent): Take from
  // api/v1/instance:configuration.statuses.supported_media_types
  @override
  Set<Formatting> get supportedFormattings {
    return const {
      Formatting.plainText,
      Formatting.markdown,
    };
  }

  // TODO(erincandescent): Enable if
  // api/v1/instance:configuration.reactions exists
  @override
  bool get supportsCustomEmojiReactions => false;
  @override
  bool get supportsUnicodeEmojiReactions => false;
  @override
  bool get supportsMultipleReactions => false;
}
