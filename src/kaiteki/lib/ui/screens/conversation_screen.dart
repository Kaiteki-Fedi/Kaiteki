import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:mdi/mdi.dart';

class ConversationScreen extends ConsumerWidget {
  final Post post;

  const ConversationScreen(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adapter = ref.watch(accountProvider).adapter;
    final l10n = context.getL10n();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.conversationTitle)),
      body: FutureBuilder(
        future: adapter.getThread(post),
        builder: (_, AsyncSnapshot<Iterable<Post>> snapshot) {
          if (snapshot.hasData) {
            var cookedThread = Threader.toThread(snapshot.data!);
            return SingleChildScrollView(
              child: ThreadPostContainer(cookedThread),
            );
          } else if (snapshot.hasError) {
            return Column(
              children: [
                StatusWidget(post),
                ListTile(
                  leading: const Icon(Mdi.close),
                  title: Text(l10n.threadRetrievalFailed),
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
    var threadPosts = posts.map((post) => ThreadPost(post)).toList();

    for (var post in threadPosts) {
      var id = post.post.replyToPostId;

      if (id != null) {
        var parent = threadPosts.firstWhere((p) => p.post.id == id);
        parent.replies.add(post);
        post.parent = parent;
      }
    }

    var op = threadPosts.firstWhere((p) => p.post.replyToPostId == null);
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
    var opposite = maxLayer - layer; // flip values
    return 0.25 + ((opposite / maxLayer) * 0.5); // return 0.0 - 0.5
  }
}
