import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/model/model.dart';
import 'package:kaiteki/fediverse/model/timeline_query.dart';
import 'package:kaiteki/ui/shared/error_landing_widget.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
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

  late ProviderSubscription<BackendAdapter> _subscription;

  Future<List<Post>> Function(TimelineQuery<String> query) get _source {
    final adapter = _subscription.read();

    final timelineKind = widget.kind;
    if (timelineKind != null) {
      log(
        "Showing posts from $timelineKind at ${adapter.runtimeType}",
        name: "Timeline",
      );
      return (q) => adapter.getTimeline(timelineKind, query: q);
    }

    final userId = widget.userId;
    if (userId != null) {
      log(
        "Showing posts from $userId at ${adapter.runtimeType}",
        name: "Timeline",
      );
      return (q) => adapter.getStatusesOfUserById(userId, query: q);
    }

    throw StateError("Cannot fetch timeline with no post source set.");
  }

  @override
  void initState() {
    super.initState();

    _controller.addPageRequestListener((id) async {
      try {
        final query = TimelineQuery(untilId: id);
        final posts = await _source(query);

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

    _subscription = ref.listenManual(
      adapterProvider,
      (_, __) => _controller.refresh(),
    );
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

  Widget _buildPost(BuildContext context, item, index) {
    void openPost() => context.pushNamed(
          "post",
          params: {...ref.accountRouterParams, "id": item.id},
          extra: item,
        );

    return Material(
      child: InkWell(
        onTap: openPost,
        child: PostWidget(
          item,
          wide: widget.wide,
          onTap: openPost,
        ),
      ),
    );
  }

  Widget _buildSeparator(BuildContext context, int index) {
    return const Divider(height: 1);
  }
}
