import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki_core/social.dart";

class BookmarksPage extends ConsumerStatefulWidget {
  const BookmarksPage({super.key});

  @override
  ConsumerState<BookmarksPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends ConsumerState<BookmarksPage> {
  final _pagingController = PagingController<String?, Post>(
    firstPageKey: null,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((id) async {
      try {
        final adapter = ref.watch(adapterProvider) as BookmarkSupport;
        final posts = await adapter.getBookmarks(sinceId: id);

        if (posts.isEmpty) {
          _pagingController.appendLastPage(posts.toList());
        } else {
          _pagingController.appendPage(posts.toList(), posts.last.id);
        }
      } catch (e) {
        _pagingController.error = e;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        return PagedListView<String?, Post>.separated(
          padding: EdgeInsets.symmetric(
            horizontal: getPadding(constraints.maxWidth),
          ),
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Post>(
            itemBuilder: _buildPost,
            noItemsFoundIndicatorBuilder: (_) => IconLandingWidget(
              icon: const Icon(Icons.bookmark_outline_rounded),
              text: Text(l10n.bookmarksEmpty),
            ),
          ),
          separatorBuilder: _buildSeparator,
        );
      },
    );
  }

  double getPadding(double width) {
    const maxWidth = 800;
    if (width <= maxWidth) {
      return 0;
    } else {
      return width / 2 - maxWidth / 2;
    }
  }

  Widget _buildPost(BuildContext context, Post item, int index) {
    return Consumer(
      builder: (context, ref, child) {
        return Material(
          child: InkWell(
            onTap: () {
              final accountKey = ref.read(accountProvider)!.key;
              final username = accountKey.username;
              final instance = accountKey.host;

              context.push(
                "/@$username@$instance/posts/${item.id}",
                extra: item,
              );
            },
            child: PostWidget(item),
          ),
        );
      },
    );
  }

  Widget _buildSeparator(BuildContext context, int index) {
    return const Divider(height: 1);
  }
}
