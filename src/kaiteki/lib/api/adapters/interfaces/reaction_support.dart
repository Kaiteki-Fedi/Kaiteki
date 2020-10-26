import 'package:kaiteki/model/fediverse/emoji.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/model/fediverse/reaction.dart';

abstract class ReactionSupport {
  bool supportsUnicodeEmoji;
  bool supportsCustomEmoji;

  Future<void> react(Post post, Emoji emoji);

  Future<Iterable<Reaction>> getReactions(Post post);
}