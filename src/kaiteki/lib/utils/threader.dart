import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/widgets/post_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

ThreadPost toThread(Iterable<Post> posts) {
  final threadPosts = posts.map((post) => ThreadPost(post.getRoot())).toList();

  for (final post in threadPosts) {
    final id = post.post.replyToPostId;

    if (id != null) {
      final parent = threadPosts.firstWhere((p) => p.post.id == id);
      parent.replies.add(post);
      post.parent = parent;
    }
  }

  final op = threadPosts.firstWhere((p) => p.post.replyToPostId == null);
  return op;
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
    Key? key,
  }) : super(key: key);

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
              child: PostWidget(
                post.post,
                showParentPost: false,
                hideReplyee: true,
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
                for (var reply in post.replies)
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
    layer = math.min(layer, maxLayer); // make sure maxLayer or less is taken
    final opposite = maxLayer - layer; // flip values
    return 0.25 + ((opposite / maxLayer) * 0.5); // return 0.0 - 0.5
  }
}
