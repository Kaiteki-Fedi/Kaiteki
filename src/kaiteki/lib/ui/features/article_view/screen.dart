import "package:collection/collection.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/error_landing_widget.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/ui/shared/posts/user_list_dialog.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/threader.dart";

class ArticleViewScreen extends ConsumerStatefulWidget {
  final Post post;

  const ArticleViewScreen({
    required this.post,
    super.key,
  });

  @override
  ConsumerState<ArticleViewScreen> createState() => _ArticleViewScreenState();
}

class _ArticleViewScreenState extends ConsumerState<ArticleViewScreen> {
  Future<Iterable<Post>>? _threadFuture;

  @override
  void initState() {
    super.initState();

    final adapter = ref.read(adapterProvider);
    _threadFuture = adapter
        .getThread(widget.post)
        .then((posts) => compute(toThread, posts.toList(growable: false)))
        .then(getPostString);
  }

  /// Returns a thread of posts which are consecutive replies from the original
  /// poster.
  Iterable<Post> getPostString(ThreadPost thread) sync* {
    final op = thread.post;

    yield op;

    for (final reply in thread.replies) {
      if (reply.post.author.id != op.author.id) continue;
      yield* getPostString(reply);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _threadFuture,
      builder: (context, snapshot) {
        final posts = snapshot.data;
        final title = posts?.firstOrNull?.subject;

        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (_, innerBoxIsScrolled) => [
              SliverAppBar(
                title: innerBoxIsScrolled //
                    ? title.nullTransform(Text.new)
                    : null,
                pinned: true,
              ),
            ],
            body: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: CustomScrollView(
                  slivers: [
                    if (snapshot.hasError)
                      SliverFillRemaining(
                        child: ErrorLandingWidget.fromAsyncSnapshot(snapshot),
                      )
                    else if (!snapshot.hasData)
                      const SliverFillRemaining(
                        child: centeredCircularProgressIndicator,
                      )
                    else if (posts != null)
                      ..._buildThread(posts),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Iterable<Widget> _buildThread(Iterable<Post> posts) sync* {
    final op = posts.firstOrNull;

    if (op == null) {
      yield const SliverFillRemaining(
        child: IconLandingWidget(
          icon: Icon(Icons.insert_page_break_rounded),
          text: Text("Hmm... no posts?"),
        ),
      );
      return;
    }

    final title = op.subject;

    yield SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null && title.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          UserListTile(user: op.author),
        ],
      ),
    );

    yield SliverList.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts.elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final attachment in post.attachments ?? [])
              if (attachment.type == AttachmentType.image)
                Image.network(attachment.url.toString()),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: SelectableText.rich(
                TextSpan(
                  children: [post.renderContent(context, ref)],
                ),
              ),
            ),
          ],
        );
      },
      addSemanticIndexes: false,
      // separatorBuilder: (_, __) => const Divider(indent: 16, endIndent: 16),
    );

    Widget buildFooterButton(
      String text,
      IconData icon,
      void Function() onTap,
    ) {
      return RawMaterialButton(
        onPressed: () {},
        shape: const StadiumBorder(),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(text),
          ],
        ),
      );
    }

    yield SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: buildFooterButton(
                "${op.metrics.replyCount} Replies",
                Icons.reply_rounded,
                () {},
              ),
            ),
            Expanded(
              child: buildFooterButton(
                "${op.metrics.favoriteCount} Favorites",
                Icons.favorite_rounded,
                () {},
              ),
            ),
            Expanded(
              child: buildFooterButton(
                "${op.metrics.favoriteCount} Repeats",
                Icons.repeat_rounded,
                () {},
              ),
            ),
          ].joinWithValue(const SizedBox(width: 8)),
        ),
      ),
    );
  }
}
