import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/bookmark_support.dart';
import 'package:kaiteki/fediverse/model/model.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';

class BookmarksPage extends ConsumerStatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

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
        final adapter = ref.watch(accountProvider).adapter as BookmarkSupport;
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return PagedListView<String?, Post>.separated(
          padding: EdgeInsets.symmetric(
            horizontal: getPadding(constraints.maxWidth),
          ),
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Post>(
            itemBuilder: _buildPost,
            noItemsFoundIndicatorBuilder: (_) => const IconLandingWidget(
              icon: Icon(Icons.bookmark_outline_rounded),
              text: Text("No bookmarks"),
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

  Widget _buildPost(context, item, index) {
    return Consumer(
      builder: (context, ref, child) {
        return Material(
          child: InkWell(
            onTap: () {
              final account =
                  ref.read(accountProvider).currentAccount.accountSecret;
              context.push(
                "/@${account.username}@${account.instance}/posts/${item.id}",
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
