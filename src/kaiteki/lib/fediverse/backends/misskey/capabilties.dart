import 'package:kaiteki/fediverse/capabilities.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';

class MisskeyCapabilities extends AdapterCapabilities
    implements ReactionSupportCapabilities {
  @override
  bool get supportsCustomEmojiReactions => true;

  @override
  bool get supportsScopes => true;

  @override
  bool get supportsUnicodeEmojiReactions => true;

  const MisskeyCapabilities();
}
