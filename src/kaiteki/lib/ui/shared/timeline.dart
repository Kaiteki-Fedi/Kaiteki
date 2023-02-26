import "dart:developer";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/interfaces/list_support.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/fediverse/model/timeline_query.dart";
import "package:kaiteki/ui/shared/error_landing_widget.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:tuple/tuple.dart";

class TimelineSliver extends ConsumerStatefulWidget {
  final double? maxWidth;
  final bool wide;
  final TimelineKind? kind;
  final String? userId;
  final String? listId;
  final bool includeReplies;

  const TimelineSliver.kind({
    super.key,
    this.maxWidth,
    this.wide = false,
    this.kind = TimelineKind.home,
    this.includeReplies = true,
  })  : userId = null,
        listId = null;

  const TimelineSliver.user({
    super.key,
    this.maxWidth,
    this.wide = false,
    required String this.userId,
    this.includeReplies = true,
  })  : kind = null,
        listId = null;

  const TimelineSliver.list({
    super.key,
    this.maxWidth,
    this.wide = false,
    required String this.listId,
    this.includeReplies = true,
  })  : kind = null,
        userId = null;

  @override
  TimelineState createState() => TimelineState();
}

class TimelineState extends ConsumerState<TimelineSliver> {
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

    final listId = widget.listId;
    if (listId != null) {
      log(
        "Showing posts from $listId at ${adapter.runtimeType}",
        name: "Timeline",
      );
      final listAdapter = adapter as ListSupport;
      return (q) => listAdapter.getListPosts(listId, query: q);
    }

    throw StateError("Cannot fetch timeline with no post source set.");
  }

  @override
  void initState() {
    super.initState();

    _controller.addPageRequestListener((id) async {
      try {
        final query = TimelineQuery(
          untilId: id,
          includeReplies: widget.includeReplies,
        );
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
  void didUpdateWidget(covariant TimelineSliver oldWidget) {
    if (widget.kind != oldWidget.kind ||
        widget.userId != oldWidget.userId ||
        widget.listId != oldWidget.listId ||
        widget.includeReplies != oldWidget.includeReplies) {
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
    return PagedSliverList<String?, Post>.separated(
      pagingController: _controller,
      builderDelegate: PagedChildBuilderDelegate<Post>(
        itemBuilder: _buildPost,
        animateTransitions: true,
        firstPageErrorIndicatorBuilder: (context) {
          final t = _controller.error as Tuple2<Object, StackTrace>;
          return Center(
            child: ErrorLandingWidget(
              error: t.item1,
              stackTrace: t.item2,
            ),
          );
        },
        noMoreItemsIndicatorBuilder: (context) {
          final l10n = context.l10n;
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
  }

  Widget _buildPost(BuildContext context, Post item, int index) {
    void openPost() => context.pushNamed(
          "post",
          params: {...ref.accountRouterParams, "id": item.id},
          extra: item,
        );

    return InkWell(
      onTap: openPost,
      child: PostWidget(
        item,
        layout: widget.wide ? PostWidgetLayout.wide : PostWidgetLayout.normal,
        onTap: openPost,
      ),
    );
  }

  Widget _buildSeparator(BuildContext context, int index) {
    return const Divider(height: 1);
  }
}

class Timeline extends StatelessWidget {
  final double? maxWidth;
  final bool wide;
  final TimelineKind? kind;
  final String? userId;
  final String? listId;

  const Timeline.kind({
    super.key,
    this.maxWidth,
    this.wide = false,
    this.kind = TimelineKind.home,
  })  : userId = null,
        listId = null;

  const Timeline.user({
    super.key,
    this.maxWidth,
    this.wide = false,
    required String this.userId,
  })  : kind = null,
        listId = null;

  const Timeline.list({
    super.key,
    this.maxWidth,
    this.wide = false,
    required String this.listId,
  })  : kind = null,
        userId = null;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [_getSliver()],
    );
  }

  TimelineSliver _getSliver() {
    if (kind != null) return TimelineSliver.kind(kind: kind);
    if (listId != null) return TimelineSliver.list(listId: listId!);
    if (userId != null) return TimelineSliver.user(userId: userId!);
    throw UnimplementedError();
  }
}
