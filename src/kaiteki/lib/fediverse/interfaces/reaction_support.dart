import 'package:kaiteki/fediverse/model/emoji.dart';
import 'package:kaiteki/fediverse/model/post.dart';

abstract class ReactionSupport {
  late bool supportsUnicodeEmoji;
  late bool supportsCustomEmoji;

  Future<void> addReaction(Post post, Emoji emoji);

  Future<void> removeReaction(Post post, Emoji emoji);
}
