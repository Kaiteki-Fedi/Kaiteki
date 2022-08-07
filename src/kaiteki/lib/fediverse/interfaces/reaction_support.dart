import 'package:kaiteki/fediverse/capabilities.dart';
import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/fediverse/model/post.dart';

abstract class ReactionSupport {
  ReactionSupportCapabilities get capabilities;

  Future<Post> addReaction(Post post, Emoji emoji);

  Future<Post> removeReaction(Post post, Emoji emoji);
}

abstract class ReactionSupportCapabilities extends AdapterCapabilities {
  bool get supportsUnicodeEmojiReactions;
  bool get supportsCustomEmojiReactions;

  const ReactionSupportCapabilities();
}
