import "package:collection/collection.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/main/views/view.dart";
import "package:kaiteki/ui/shared/posts/attachments/attachment_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";

class CatalogMainScreenView extends ConsumerStatefulWidget
    implements MainScreenView {
  final Widget Function(TabKind tab) getPage;
  final TabKind tab;
  final Function(TabKind tab) onChangeTab;
  final Function(MainScreenViewType view) onChangeView;

  const CatalogMainScreenView({
    super.key,
    required this.getPage,
    required this.onChangeTab,
    required this.tab,
    required this.onChangeView,
  });

  @override
  ConsumerState<CatalogMainScreenView> createState() =>
      _CatalogMainScreenViewState();
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
        if (mounted) _controller.error = (e, s);
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
    TextSpan buildTextButton(String text, VoidCallback onTap) {
      return TextSpan(
        text: "[",
        children: [
          TextSpan(
            text: text,
            recognizer: TapGestureRecognizer()..onTap = onTap,
            style: Theme.of(context).ktkTextTheme?.linkTextStyle ??
                DefaultKaitekiTextTheme(context).linkTextStyle,
          ),
          const TextSpan(text: "]"),
        ],
      );
    }

    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => context.pushNamed("accounts"),
                    child: Text(
                      ref.watch(accountProvider)!.key.host,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    buildTextButton(
                      "Start a New Thread",
                      () => context.pushNamed(
                        "compose",
                        pathParameters: ref.accountRouterParams,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text.rich(
                        buildTextButton(
                          "Return",
                          () => widget.onChangeView(MainScreenViewType.stream),
                        ),
                      ),
                      Text.rich(
                        buildTextButton(
                          "Refresh",
                          _controller.refresh,
                        ),
                      ),
                      const Spacer(),
                      Text.rich(
                        buildTextButton(
                          "Search",
                          () => context.pushNamed(
                            "search",
                            pathParameters: ref.accountRouterParams,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: PagedSliverGrid(
              pagingController: _controller,
              builderDelegate: PagedChildBuilderDelegate<Post>(
                itemBuilder: _buildPost,
              ),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 24,
                crossAxisSpacing: 30,
                childAspectRatio: 8 / 12,
              ),
            ),
          ),
        ],
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
          Text.rich(
            TextSpan(
              text: "R: ",
              style: Theme.of(context).textTheme.labelSmall,
              children: [
                TextSpan(
                  text: item.metrics.replyCount.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
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
