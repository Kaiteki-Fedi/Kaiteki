import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/model/fediverse/reaction.dart';

abstract class ReactionSupport {
  Future<void> react(Post post, Reaction reaction);

  Future<Iterable<Reaction>> getReactions();
}