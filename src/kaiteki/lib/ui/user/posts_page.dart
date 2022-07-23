import 'package:flutter/material.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';
import 'package:kaiteki/ui/user/user_screen.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({
    super.key,
    required this.container,
    required this.widget,
  });

  final AccountManager container;
  final UserScreen widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<Post>>(
      future: container.adapter.getStatusesOfUserById(widget.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return ListView.builder(
          itemBuilder: (_, i) => PostWidget(snapshot.data!.elementAt(i)),
          itemCount: snapshot.data?.length ?? 0,
        );
      },
    );
  }
}
