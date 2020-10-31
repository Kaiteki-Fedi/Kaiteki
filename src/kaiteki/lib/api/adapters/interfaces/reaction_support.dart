import 'package:kaiteki/model/fediverse/emoji.dart';
import 'package:kaiteki/model/fediverse/post.dart';

abstract class ReactionSupport {
  bool supportsUnicodeEmoji;
  bool supportsCustomEmoji;

  Future<void> addReaction(Post post, Emoji emoji);

  Future<void> removeReaction(Post post, Emoji emoji);
}
