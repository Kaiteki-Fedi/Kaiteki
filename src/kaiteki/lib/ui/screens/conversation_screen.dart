import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatelessWidget {
  final Post post;

  ConversationScreen(this.post);

  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountContainer>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation'),
      ),
      body: FutureBuilder(
        future: container.adapter.getThread(post),
        builder: (_, AsyncSnapshot<Iterable<Post>> snapshot) {
          if (snapshot.hasData) {
            var cookedThread = Threader.toThread(snapshot.data!);
            return SingleChildScrollView(
              child: ThreadPostContainer(cookedThread),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: IconLandingWidget(
                Mdi.close,
                snapshot.error.toString(),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class Threader {
  static ThreadPost toThread(Iterable<Post> posts) {
    var threadPosts = posts.map((post) => new ThreadPost(post)).toList();

    for (var post in threadPosts) {
      var id = post.post.replyToPostId;

      if (id != null) {
        threadPosts.firstWhere((p) => p.post.id == id).replies.add(post);
      }
    }

    var op = threadPosts.firstWhere((p) => p.post.replyToPostId == null);
    return op;
  }
}

class ThreadPost {
  Post post;
  late List<ThreadPost> replies;

  ThreadPost(this.post, {replies}) {
    if (replies == null)
      this.replies = <ThreadPost>[];
    else
      this.replies = replies;
  }
}

class ThreadPostContainer extends StatelessWidget {
  final ThreadPost post;
  final int threadLayer;

  const ThreadPostContainer(this.post, {this.threadLayer = 0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        new StatusWidget(post.post),
        if (post.replies.isNotEmpty)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VerticalDivider(
                  thickness: 2,
                  width: 8,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(
                        getLineOpacity(threadLayer),
                      ),
                ),
                Expanded(
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
