import "dart:math" as math;

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/ui/shared/posts/post_widget_theme.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";

ThreadPost toThread(Iterable<Post> posts, {bool ignoreMissing = false}) {
  final threadPosts = posts.map((post) => ThreadPost(post.root)).toList();

  for (final post in threadPosts) {
    final id = post.post.id;
    final parentId = post.post.replyTo?.id;

    if (parentId != null) {
      final parent = threadPosts.firstWhereOrNull((p) => p.post.id == parentId);

      if (parent == null) {
        if (ignoreMissing) continue;

        throw BrokenThreadException(
          "Couldn't find parent post $parentId for $id",
        );
      }

      parent.replies.add(post);
      post.parent = parent;
    }
  }

  final op = threadPosts.firstWhereOrNull((p) => p.post.replyTo?.id == null);
  if (op == null) {
    throw Exception("Couldn't find original post for thread");
  }

  return op;
}

/// Exception thrown when a thread has posts replying to non-existent posts.
///
/// This is an indicator that the user is not authorized to view all replies.
class BrokenThreadException implements Exception {
  final String message;

  const BrokenThreadException(this.message);

  @override
  String toString() => "BrokenThreadException: $message";
}

/// A mutable class
class ThreadPost {
  final Post post;
  final List<ThreadPost> replies = <ThreadPost>[];
  ThreadPost? parent;

  bool get hasReplies => replies.isNotEmpty;

  /// Whether this post has a parent.
  ///
  /// Implies whether this post is replying to another one or not.
  bool get hasParent => parent != null;

  ThreadPost(this.post);
}

class ThreadPostContainer extends StatelessWidget {
  final ThreadPost post;
  final int threadLayer;

  bool get _hasParentMultipleReplies {
    return post.hasParent && post.parent!.replies.length > 1;
  }

  bool get _isNotReplyOfOP => threadLayer != 1;

  bool get _lineShouldShow => threadLayer != 0;

  bool get _lineShouldFillPost {
    return post.hasReplies || (_hasParentMultipleReplies && _isNotReplyOfOP);
  }

  bool get _lineShouldContinue => post.hasParent && _isNotReplyOfOP;

  bool get _lineShouldIndent => _hasParentMultipleReplies && _isNotReplyOfOP;

  const ThreadPostContainer(
    this.post, {
    this.threadLayer = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topLeft,
          children: [
            if (_lineShouldShow)
              Positioned.fill(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: _lineShouldFillPost ? null : 24.0,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: _lineShouldContinue ? 0.0 : 8.0,
                        ),
                        child: const VerticalDivider(
                          width: 64,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: EdgeInsets.only(
                left: _lineShouldIndent ? 48.0 : 0.0,
              ),
              child: PostWidgetTheme(
                data: const PostWidgetThemeData(
                  showParentPost: false,
                  showReplyee: false,
                ),
                child: PostWidget(
                  post.post,
                  layout: threadLayer == 0
                      ? PostWidgetLayout.expanded
                      : PostWidgetLayout.normal,
                ),
              ),
            ),
          ],
        ),
        if (threadLayer == 0) const Divider(),
        if (post.replies.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
              left: _lineShouldIndent ? 48.0 : 0.0,
            ),
            child: Column(
              children: [
                for (final reply in post.replies)
                  ThreadPostContainer(
                    reply,
                    threadLayer: threadLayer + 1,
                  ),
              ],
            ),
          ),
      ],
    );
  }

  static double getLineOpacity(int layer, {int maxLayer = 5}) {
    // make sure maxLayer or less is taken
    final correctedLayer = math.min(layer, maxLayer);
    final opposite = maxLayer - correctedLayer; // flip values
    return 0.25 + ((opposite / maxLayer) * 0.5); // return 0.0 - 0.5
  }
}
