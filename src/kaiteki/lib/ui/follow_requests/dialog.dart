import "package:flutter/material.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/follow_requests.dart";
import "package:kaiteki/model/pagination_state.dart";
import "package:kaiteki/ui/shared/error_landing_widget.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/ui/shared/posts/user_list_dialog.dart";
import "package:kaiteki/ui/window_class.dart";
import "package:kaiteki_core/model.dart";
import "package:kaiteki_core/utils.dart";

class FollowRequestsDialog extends ConsumerStatefulWidget {
  const FollowRequestsDialog({super.key});

  @override
  ConsumerState<FollowRequestsDialog> createState() =>
      _FollowRequestsDialogState();
}

class _FollowRequestsDialogState extends ConsumerState<FollowRequestsDialog> {
  late final _controller = PagingController<String?, User>(firstPageKey: null);
  ProviderSubscription<AsyncValue<PaginationState<User>>>? _followRequests;

  @override
  void initState() {
    super.initState();

    _controller.addPageRequestListener((pageKey) async {
      final key = ref.read(currentAccountProvider)!.key;
      final provider = followRequestsServiceProvider(key);
      await ref.read(provider.notifier).loadMore();
    });

    ref.listenManual(
      currentAccountProvider,
      (previous, next) {
        final provider = followRequestsServiceProvider(next!.key);

        _followRequests?.close();
        _followRequests = ref.listenManual(
          provider,
          (_, e) => _controller.value = e.getPagingState(null),
          fireImmediately: true,
        );
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(currentAccountProvider)!.key;

    final body = PagedListView<String?, User>.separated(
      pagingController: _controller,
      separatorBuilder: (_, __) => const Divider(),
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, user, i) => UserListTile(
          user: user,
          titleAlignment: ListTileTitleAlignment.center,
          content: [
            const SizedBox(height: 8),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () async {
                    await ref
                        .read(followRequestsServiceProvider(account).notifier)
                        .accept(user.id);
                  },
                  icon: Icon(Icons.check_rounded),
                  label: const Text("Accept"),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    await ref
                        .read(followRequestsServiceProvider(account).notifier)
                        .reject(user.id);
                  },
                  icon: Icon(Icons.close_rounded),
                  label: const Text("Reject"),
                ),
              ],
            ),
          ],
          avatarSize: 48.0,
        ),
        firstPageErrorIndicatorBuilder: (_) {
          return Center(
            child: ErrorLandingWidget(
              _controller.error as TraceableError,
            ),
          );
        },
        noItemsFoundIndicatorBuilder: (_) {
          return const Center(
            child: IconLandingWidget(
              icon: Icon(Icons.sentiment_dissatisfied_rounded),
              text: Text("There are no pending follow requests"),
            ),
          );
        },
      ),
    );

    final refreshButton = IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () => ref.refresh(followRequestsServiceProvider(account)),
    );

    final closeButton = IconButton(
      icon: const Icon(Icons.close),
      onPressed: () => Navigator.of(context).pop(),
    );

    if (WindowClass.fromContext(context) <= WindowClass.compact) {
      return Dialog.fullscreen(
        child: Column(
          children: [
            AppBar(
              leading: closeButton,
              title: const Text("Follow requests"),
              forceMaterialTransparency: true,
              actions: [refreshButton, const SizedBox(width: 8)],
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: kDialogConstraints.copyWith(
          maxHeight: kDialogConstraints.maxWidth,
        ),
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Follow requests"),
              forceMaterialTransparency: true,
              actions: [refreshButton, closeButton, const SizedBox(width: 8)],
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
