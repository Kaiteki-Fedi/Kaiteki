import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/timeline_kind.dart';
import 'package:kaiteki/model/post_filters/post_filter.dart';
import 'package:kaiteki/ui/shared/error_landing_widget.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';

class Timeline extends ConsumerStatefulWidget {
  final List<PostFilter>? filters;
  final double? maxWidth;
  final bool wide;
  final TimelineKind kind;

  const Timeline({
    Key? key,
    this.filters,
    this.maxWidth,
    this.wide = false,
    this.kind = TimelineKind.home,
  }) : super(key: key);

  @override
  TimelineState createState() => TimelineState();
}

class TimelineState extends ConsumerState<Timeline> {
  final PagingController<String?, Post> _controller = PagingController(
    firstPageKey: null,
  );

  @override
  void initState() {
    _controller.addPageRequestListener((id) async {
      try {
        final adapter = ref.watch(accountProvider).adapter;
        final posts = await adapter.getTimeline(widget.kind, untilId: id);

        if (mounted) {
          if (posts.isEmpty) {
            _controller.appendLastPage(posts.toList());
          } else {
            _controller.appendPage(posts.toList(), posts.last.id);
          }
        }
      } catch (e) {
        if (mounted) _controller.error = e;
      }
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant Timeline oldWidget) {
    if (widget.kind != oldWidget.kind) {
      _controller.refresh();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void refresh() => _controller.refresh();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return PagedListView<String?, Post>.separated(
          padding: EdgeInsets.symmetric(
            horizontal: _getPadding(constraints.maxWidth),
          ),
          pagingController: _controller,
          builderDelegate: PagedChildBuilderDelegate<Post>(
            itemBuilder: _buildPost,
            firstPageErrorIndicatorBuilder: (context) {
              return ErrorLandingWidget(
                error: _controller.error,
              );
            },
          ),
          separatorBuilder: _buildSeparator,
        );
      },
    );
  }

  double _getPadding(double width) {
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
