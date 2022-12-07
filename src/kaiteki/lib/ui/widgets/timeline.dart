import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/timeline_kind.dart';
import 'package:kaiteki/fediverse/model/timeline_query.dart';
import 'package:kaiteki/ui/shared/error_landing_widget.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';
import 'package:tuple/tuple.dart';

class Timeline extends ConsumerStatefulWidget {
  final double? maxWidth;
  final bool wide;
  final TimelineKind? kind;
  final String? userId;

  const Timeline.kind({
    super.key,
    this.maxWidth,
    this.wide = false,
    this.kind = TimelineKind.home,
  }) : userId = null;

  const Timeline.user({
    super.key,
    this.maxWidth,
    this.wide = false,
    required String this.userId,
  }) : kind = null;

  @override
  TimelineState createState() => TimelineState();
}

class TimelineState extends ConsumerState<Timeline> {
  final PagingController<String?, Post> _controller = PagingController(
    firstPageKey: null,
  );

  @override
  void initState() {
    super.initState();

    _controller.addPageRequestListener((id) async {
      try {
        final adapter = ref.watch(adapterProvider);
        final Iterable<Post> posts;
        final query = TimelineQuery(untilId: id);

        if (widget.kind != null) {
          posts = await adapter.getTimeline(widget.kind!, query: query);
        } else if (widget.userId != null) {
          posts = await adapter.getStatusesOfUserById(
            widget.userId!,
            query: query,
          );
        } else {
          throw StateError("Cannot fetch timeline with no post source set.");
        }

        if (mounted) {
          if (posts.isEmpty) {
            _controller.appendLastPage(posts.toList());
          } else {
            _controller.appendPage(posts.toList(), posts.last.id);
          }
        }
      } catch (e, s) {
        if (mounted) _controller.error = Tuple2(e, s);
      }
    });
  }

  @override
  void didUpdateWidget(covariant Timeline oldWidget) {
    if (widget.kind != oldWidget.kind || widget.userId != oldWidget.userId) {
      _controller.refresh();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void refresh() {
    _controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(accountProvider, (_, __) => _controller.refresh());

    return RefreshIndicator(
      onRefresh: () => Future.sync(_controller.refresh),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return PagedListView<String?, Post>.separated(
            pagingController: _controller,
            padding: EdgeInsets.symmetric(
              horizontal: _getPadding(constraints.maxWidth),
            ),
            builderDelegate: PagedChildBuilderDelegate<Post>(
              itemBuilder: _buildPost,
              animateTransitions: true,
              firstPageErrorIndicatorBuilder: (context) {
                final t = _controller.error as Tuple2<dynamic, StackTrace>;
                return Center(
                  child: ErrorLandingWidget(
                    error: t.item1,
                    stackTrace: t.item2,
                  ),
                );
              },
              noMoreItemsIndicatorBuilder: (context) {
                final l10n = context.getL10n();
                return Align(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      l10n.noMorePosts,
                      style: TextStyle(color: Theme.of(context).disabledColor),
                    ),
                  ),
                );
              },
            ),
            separatorBuilder: _buildSeparator,
          );
        },
      ),
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
              final account = ref.read(accountProvider).current;
              context.push(
                "/@${account.key.username}@${account.key.host}/posts/${item.id}",
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
