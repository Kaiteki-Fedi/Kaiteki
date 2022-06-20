import 'package:kaiteki/fediverse/backends/mastodon/capabilities.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';

class PleromaCapabilities extends MastodonCapabilities
    implements ReactionSupportCapabilities {
  @override
  bool get supportsCustomEmojiReactions => false;

  @override
  bool get supportsUnicodeEmojiReactions => true;

  const PleromaCapabilities();
}
