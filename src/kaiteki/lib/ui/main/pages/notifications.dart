import "package:collection/collection.dart";
import "package:flutter/material.dart" hide Notification;
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/notifications.dart";
import "package:kaiteki/model/pagination_state.dart";
import "package:kaiteki/ui/notification_widget.dart";
import "package:kaiteki/ui/shared/error_landing_widget.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  late final _controller =
      PagingController<String?, Notification>(firstPageKey: null);
  ProviderSubscription<AsyncValue<PaginationState<Notification>>>?
      _notifications;

  @override
  void initState() {
    super.initState();

    _controller.addPageRequestListener((pageKey) async {
      final key = ref.read(currentAccountProvider)!.key;
      final provider = notificationServiceProvider(key);
      await ref.read(provider.notifier).loadMore();
    });
    ref.listenManual(
      currentAccountProvider,
      (previous, next) {
        final provider = NotificationServiceProvider(next!.key);

        _notifications?.close();
        _notifications = ref.listenManual(
          provider,
          (_, e) => _controller.value = e.getPagingState(
            "",
            intercept: groupNotifications,
          ),
          fireImmediately: true,
        );
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(currentAccountProvider);

    if (account == null) return IconLandingWidget.notSignedIn();

    if (account.adapter is! NotificationSupport) {
      return const Center(
        child: IconLandingWidget(
          icon: Icon(Icons.notifications_off_rounded),
          // TODO(Craftplacer): Add name of backend to make it clear that the backend doesn't support it.
          text: Text("Notifications are not supported"),
        ),
      );
    }

    final notifications = notificationServiceProvider(account.key);

    final hasUnread = ref
        .watch(notifications)
        .valueOrNull
        ?.items
        .any((e) => e.unread == true);
    return RefreshIndicator(
      onRefresh: () async => await ref.refresh(notifications),
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(4.0),
                sliver: PagedSliverList<String?, Notification>(
                  pagingController: _controller,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, notification, i) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: NotificationWidget(notification),
                        ),
                      );
                    },
                    firstPageErrorIndicatorBuilder: (_) {
                      return Center(
                        child: ErrorLandingWidget(
                          _controller.error as TraceableError,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          if (hasUnread == true)
            const Positioned(
              bottom: kFloatingActionButtonMargin,
              left: kFloatingActionButtonMargin,
              right: kFloatingActionButtonMargin,
              child: Align(
                child: _MarkAsReadFAB(),
              ),
            ),
        ],
      ),
    );
  }

  List<Notification> groupNotifications(List<Notification> ungrouped) {
    final groups = ungrouped.groupBy((e) {
      String? followRequestValue;

      if (e.type == NotificationType.incomingFollowRequest ||
          e.type == NotificationType.outgoingFollowRequestAccepted) {
        followRequestValue = e.user?.id;
      }

      return (
        e.type,
        e.post?.id,
        followRequestValue,
      );
    });

    return groups.entries
        .map((kv) {
          final notifications = kv.value;

          if (notifications.length < 2) return kv.value.toList();

          return [GroupedNotification(notifications.toList())];
        })
        .flattened
        .toList();
  }
}

class _MarkAsReadFAB extends ConsumerWidget {
  const _MarkAsReadFAB();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () {
        final accountKey = ref.read(currentAccountProvider)!.key;
        final service =
            ref.read(notificationServiceProvider(accountKey).notifier);
        service
            .markAllAsRead()
            .onError<Object>((e, s) => _onError(context, e, s));
      },
      label: const Text("Mark all as read"),
      icon: const Icon(Icons.done_all_rounded),
    );
  }

  void _onError(BuildContext context, Object error, StackTrace stackTrace) {
    final messenger = ScaffoldMessenger.of(context);
    final snackBar = SnackBar(
      content: const Text("Failed to mark notification as read"),
      action: SnackBarAction(
        label: context.l10n.showDetailsButtonLabel,
        onPressed: () => context.showExceptionDialog((error, stackTrace)),
      ),
    );
    messenger.showSnackBar(snackBar);
  }
}
