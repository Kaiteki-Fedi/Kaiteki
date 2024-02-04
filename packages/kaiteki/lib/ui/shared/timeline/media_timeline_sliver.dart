import "package:flutter/material.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/timeline.dart";
import "package:kaiteki/model/pagination_state.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/error_landing_widget.dart";
import "package:kaiteki/ui/shared/timeline/source.dart";
import "package:kaiteki_core/kaiteki_core.dart";

typedef PostWithAttachment = (Post post, Attachment attachment);

class MediaTimelineSliver extends ConsumerStatefulWidget {
  final double? maxWidth;
  final TimelineSource source;
  final bool includeReplies;
  final Widget Function(BuildContext, PostWithAttachment) tileBuilder;
  final SliverGridDelegate gridDelegate;

  const MediaTimelineSliver(
    this.source, {
    super.key,
    this.maxWidth,
    this.includeReplies = true,
    required this.tileBuilder,
    required this.gridDelegate,
  });

  @override
  MediaTimelineSliverState createState() => MediaTimelineSliverState();
}

class MediaTimelineSliverState extends ConsumerState<MediaTimelineSliver> {
  late final _controller =
      PagingController<String?, PostWithAttachment>(firstPageKey: null);
  ProviderSubscription<AsyncValue<PaginationState<Post>>>? _timeline;

  @override
  void initState() {
    super.initState();

    _controller.addPageRequestListener((pageKey) {
      final key = ref.read(currentAccountProvider)!.key;
      final provider = TimelineServiceProvider(key, widget.source);
      ref.read(provider.notifier).loadMore();
    });

    ref.listenManual(
      currentAccountProvider,
      (previous, next) {
        final provider = TimelineServiceProvider(next!.key, widget.source);

        _timeline?.close();
        _timeline = ref.listenManual(
          provider,
          (_, e) {
            final pagingState = e.getPagingState("");
            final items = pagingState.itemList?.expand<PostWithAttachment>(
              (post) sync* {
                final attachments = post.attachments;
                if (attachments == null || attachments.isEmpty) return;

                for (final attachment in attachments) {
                  yield (post, attachment);
                }
              },
            );
            _controller.value = PagingState(
              nextPageKey: pagingState.nextPageKey,
              error: pagingState.error,
              itemList: items?.toList(),
            );
          },
          fireImmediately: true,
        );
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PagedSliverGrid<String?, PostWithAttachment>(
      pagingController: _controller,
      builderDelegate: PagedChildBuilderDelegate<PostWithAttachment>(
        itemBuilder: (context, item, _) => widget.tileBuilder(context, item),
        animateTransitions: true,
        firstPageErrorIndicatorBuilder: (context) {
          return Center(
            child: ErrorLandingWidget(_controller.error as TraceableError),
          );
        },
        firstPageProgressIndicatorBuilder: (context) => const Padding(
          padding: EdgeInsets.all(32),
          child: centeredCircularProgressIndicator,
        ),
        noMoreItemsIndicatorBuilder: (context) {
          final l10n = context.l10n;
          return Center(
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
      gridDelegate: widget.gridDelegate,
    );
  }
}
