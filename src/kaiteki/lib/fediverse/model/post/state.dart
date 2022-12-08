import 'package:copy_with_extension/copy_with_extension.dart';

part 'state.g.dart';

/// Represents the post state for the signed-in user.
@CopyWith()
class PostState {
  /// Whether the user has liked (favorited) this post
  final bool favorited;

  /// Whether the user has repeated (boosted, retweeted, etc.) this post
  final bool repeated;

  final bool bookmarked;

  final bool pinned;

  const PostState({
    this.favorited = false,
    this.repeated = false,
    this.bookmarked = false,
    this.pinned = false,
  });
}
