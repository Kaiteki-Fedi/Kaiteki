import 'package:kaiteki_core/social.dart';

abstract class ReactionSupport {
  ReactionSupportCapabilities get capabilities;

  Future<void> addReaction(Post post, Emoji emoji);
  Future<void> removeReaction(Post post, Emoji emoji);
}

abstract class ReactionSupportCapabilities extends AdapterCapabilities {
  bool get supportsUnicodeEmojiReactions;
  bool get supportsCustomEmojiReactions;

  /// Whether the backend supports multiple reactions per user
  bool get supportsMultipleReactions;

  const ReactionSupportCapabilities();
}
