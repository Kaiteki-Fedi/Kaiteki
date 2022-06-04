import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/timeline_type.dart';
import 'package:kaiteki/model/post_filters/post_filter.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';

class Timeline extends ConsumerStatefulWidget {
  final List<PostFilter>? filters;
  final double? maxWidth;
  final bool wide;

  const Timeline({
    Key? key,
    this.filters,
    this.maxWidth,
    this.wide = false,
  }) : super(key: key);

  @override
  TimelineState createState() => TimelineState();
}

class TimelineState extends ConsumerState<Timeline> {
  final PagingController<String?, Post> _pagingController = PagingController(
    firstPageKey: null,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((id) async {
      final adapter = ref.watch(accountProvider).adapter;
      final posts = await adapter.getTimeline(TimelineType.home, untilId: id);

      _pagingController.appendPage(posts.toList(), posts.last.id);
    });

    super.initState();
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
          ),
          separatorBuilder: _buildSeparator,
        );
      },
    );
  }

  double getPadding(double width) {
    final maxWidth = widget.maxWidth;
    if (maxWidth == null || width <= maxWidth) {
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
            child: PostWidget(item, wide: widget.wide),
          ),
        );
      },
    );
  }

  Widget _buildSeparator(BuildContext context, int index) {
    return const Divider(height: 1);
  }
}
