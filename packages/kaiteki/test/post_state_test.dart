import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:kaiteki_core_backends/kaiteki_core_backends.dart";

import "utils/bootstrap.dart";
import "utils/dummy_adapter.dart";

void main() {
  testWidgets("Test post widget state updating", (tester) async {
    final boot = await Bootstrapper.getInstance(
      initialAccounts: [
        Account(
          key: const AccountKey(BackendType.mastodon, "example.com", "alice"),
          adapter: DummyAdapter(),
          accountSecret: null,
          clientSecret: null,
          user: exampleUser,
        ),
      ],
    );

    final post = Post(
      id: "1",
      content: "Hello world",
      postedAt: DateTime.now(),
      author: exampleUser,
    );

    final key = GlobalKey<_TestPostWidgetState>();

    await tester.pumpWidget(
      boot.wrap(_TestPostWidget(post: post, key: key)),
    );

    final contentFinder = find.text(post.content!);

    expect(contentFinder, findsOneWidget);

    final newPost = post.copyWith(content: "Hello world 2");

    key.currentState!.post = newPost;

    await tester.pumpAndSettle();

    expect(contentFinder, findsNothing);
  });
}

class _TestPostWidget extends StatefulWidget {
  final Post post;

  const _TestPostWidget({required this.post, super.key});

  @override
  State<_TestPostWidget> createState() => _TestPostWidgetState();
}

class _TestPostWidgetState extends State<_TestPostWidget> {
  late Post _post;

  set post(Post post) => setState(() => _post = post);

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: PostWidget(_post),
        ),
      ),
    );
  }
}
