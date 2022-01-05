import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/widgets/post_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:mdi/mdi.dart';

class ConversationScreen extends ConsumerWidget {
  final Post post;

  const ConversationScreen(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adapter = ref.watch(accountProvider).adapter;
    final l10n = context.getL10n();
    final future = adapter.getThread(post.getRoot()).then((thread) {
      return compute(Threader.toThread, thread.toList(growable: false));
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.conversationTitle)),
      body: FutureBuilder<ThreadPost>(
        future: future,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: ThreadPostContainer(snapshot.data!),
            );
          } else if (snapshot.hasError) {
            return Column(
              children: [
                StatusWidget(post),
                ListTile(
                  leading: const Icon(Mdi.close),
                  title: Text(l10n.threadRetrievalFailed),
                  subtitle: Text(snapshot.error.toString()),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class Threader {
  static ThreadPost toThread(Iterable<Post> posts) {
    final threadPosts =
        posts.map((post) => ThreadPost(post.getRoot())).toList();

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
}

class ThreadPost {
  Post post;
  late List<ThreadPost> replies;
  ThreadPost? parent;

  ThreadPost(this.post, {replies}) {
    if (replies == null) {
      this.replies = <ThreadPost>[];
    } else {
      this.replies = replies;
    }
  }
}

class ThreadPostContainer extends StatelessWidget {
  final ThreadPost post;
  final int threadLayer;

  const ThreadPostContainer(
    this.post, {
    this.threadLayer = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final threadLineColor = Theme.of(context).colorScheme.onSurface;
    final isReply = post.parent != null;
    final hasReplies = post.replies.isNotEmpty;
    final hasParent = post.parent != null;
    final hasParentMultipleReplies =
        hasParent && post.parent!.replies.length > 1;
    final isNotReplyOfOP = threadLayer != 1;

    final lineShouldShow = threadLayer != 0;
    final lineShouldFillPost =
        hasReplies || (hasParentMultipleReplies && isNotReplyOfOP);
    final lineShouldContinue = isReply && isNotReplyOfOP;
    final lineShouldIndent = hasParentMultipleReplies && isNotReplyOfOP;

    return Column(
      children: [
        Stack(
          alignment: Alignment.topLeft,
          children: [
            if (lineShouldShow)
              Positioned.fill(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: lineShouldFillPost ? null : 24.0,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: lineShouldContinue ? 0.0 : 8.0,
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
                left: lineShouldIndent ? 48.0 : 0.0,
              ),
              child: StatusWidget(
                post.post,
                showParentPost: false,
              ),
            ),
          ],
        ),
        if (threadLayer == 0) const Divider(),
        if (post.replies.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
              left: lineShouldIndent ? 48.0 : 0.0,
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
    layer = min(layer, maxLayer); // make sure maxLayer or less is taken
    final opposite = maxLayer - layer; // flip values
    return 0.25 + ((opposite / maxLayer) * 0.5); // return 0.0 - 0.5
  }
}
