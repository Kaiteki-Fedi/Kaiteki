import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/fediverse/model/timeline_query.dart";
import "package:kaiteki/ui/main/views/view.dart";
import "package:kaiteki/ui/shared/posts/attachments/attachment_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:tuple/tuple.dart";

class CatalogMainScreenView extends ConsumerStatefulWidget
    implements MainScreenView {
  const CatalogMainScreenView({super.key});

  @override
  ConsumerState<CatalogMainScreenView> createState() =>
      _CatalogMainScreenViewState();

  @override
  NavigationVisibility get navigationVisibility => NavigationVisibility.compact;
}

class _CatalogMainScreenViewState extends ConsumerState<CatalogMainScreenView> {
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

        posts = await adapter.getTimeline(TimelineKind.federated, query: query);
        final filtered = posts
            .where(
              (p) =>
                  p.replyTo == null &&
                  p.repeatOf == null &&
                  p.attachments?.isNotEmpty == true &&
                  p.content != null,
            )
            .toList();

        if (mounted) {
          if (posts.isEmpty) {
            _controller.appendLastPage(filtered);
          } else {
            _controller.appendPage(filtered, posts.last.id);
          }
        }
      } catch (e, s) {
        if (mounted) _controller.error = Tuple2(e, s);
      }
    });
  }

  @override
  void didUpdateWidget(covariant CatalogMainScreenView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedGridView(
      padding: const EdgeInsets.all(8.0),
      pagingController: _controller,
      builderDelegate: PagedChildBuilderDelegate<Post>(
        itemBuilder: _buildPost,
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 24,
        crossAxisSpacing: 8,
        childAspectRatio: 8 / 12,
      ),
    );
  }

  Widget _buildPost(BuildContext context, Post item, int index) {
    final attachment = item.attachments?.firstOrNull;
    return InkWell(
      key: ValueKey(item.id),
      onTap: () {
        final accountKey = ref.read(accountProvider)!.key;
        context.push(
          "/@${accountKey.username}@${accountKey.host}/posts/${item.id}",
          extra: item,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (attachment != null)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
              child: AttachmentWidget(
                attachment: attachment,
                boxFit: BoxFit.scaleDown,
              ),
            ),
          Text(
            "R: ${item.metrics.replyCount}",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Text.rich(
            TextSpan(
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              children: [
                if (item.subject != null && item.subject!.isNotEmpty)
                  TextSpan(
                    text: "${item.subject}: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                if (item.content != null) item.renderContent(context, ref),
              ],
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
