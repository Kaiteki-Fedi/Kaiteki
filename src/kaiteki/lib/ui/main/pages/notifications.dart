import "package:collection/collection.dart";
import "package:flutter/material.dart" hide Notification;
import "package:fpdart/fpdart.dart";
import "package:go_router/go_router.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/announcements.dart";
import "package:kaiteki/fediverse/services/follow_requests.dart";
import "package:kaiteki/fediverse/services/notifications.dart";
import "package:kaiteki/model/pagination_state.dart";
import "package:kaiteki/ui/notification_widget.dart";
import "package:kaiteki/ui/shared/error_landing_widget.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/ui/window_class.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:sliver_tools/sliver_tools.dart";

part 'notifications.g.dart';

@Riverpod(dependencies: [adapter])
bool _announcementsSupported(_AnnouncementsSupportedRef ref) {
  return ref.watch(adapterProvider) is AnnouncementsSupport;
}

@Riverpod(dependencies: [adapter])
bool _followingSupported(_AnnouncementsSupportedRef ref) {
  return ref.watch(adapterProvider) is FollowSupport;
}

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
            intercept: (e) {
              var notifications = e;
              notifications = enhanceNotificationTypes(notifications);
              notifications = groupNotifications(notifications);
              return notifications;
            },
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

    return RefreshIndicator(
      onRefresh: () async => await ref.refresh(notifications),
      child: CustomScrollView(
        slivers: [
          SliverCrossAxisConstrained(
            maxCrossAxisExtent: 600,
            child: SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                    child: _SecondaryNotificationBar(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: PagedSliverList<String?, Notification>.separated(
                    pagingController: _controller,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, notification, i) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: NotificationWidget(notification),
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
          ),
        ],
      ),
    );
  }

  List<Notification> groupNotifications(List<Notification> ungrouped) {
    final groups = ungrouped.groupBy((e) {
      switch (e.type) {
        case NotificationType.incomingFollowRequest:
        case NotificationType.outgoingFollowRequestAccepted:
          return (e.type, e.user?.id);
        case NotificationType.mentioned:
        case NotificationType.replied:
          return (e.type, e.post?.threadId ?? e.post?.id);
        default:
          return (e.type, e.post?.id);
      }
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

  List<Notification> enhanceNotificationTypes(
    List<Notification> notifications,
  ) {
    final ourId = ref.read(currentAccountProvider)!.user.id;
    return notifications.map((e) {
      if (e.type == NotificationType.mentioned &&
          e.post?.replyToUser?.id == ourId) {
        return e.copyWith(type: NotificationType.replied);
      }
      return e;
    }).toList();
  }
}

class _SecondaryNotificationBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompact = WindowClass.fromContext(context) <= WindowClass.compact;

    final isAnnouncementsSupported = ref.watch(_announcementsSupportedProvider);
    final isFollowingSupported = ref.watch(_followingSupportedProvider);

    final buttons = <Widget>[
      if (isAnnouncementsSupported)
        Expanded(
          flex: isCompact ? 1 : 0,
          child: _AnnouncementsButton(isCompact: isCompact),
        ),
      if (isFollowingSupported)
        Expanded(
          flex: isCompact ? 1 : 0,
          child: _FollowRequestsButton(expand: isCompact),
        )
    ];

    if (buttons.isEmpty) return const SizedBox.shrink();

    const divider = SizedBox(
      height: 24,
      child: VerticalDivider(width: 8 + 8 + 1),
    );

    return Row(
      children: buttons.intersperse(divider).toList(),
    );
  }
}

class _AnnouncementsButton extends ConsumerWidget {
  const _AnnouncementsButton({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(_unreadAnnouncementCountProvider).valueOrNull;
    return TextButton(
      onPressed: () {
        context.pushNamed(
          "announcements",
          pathParameters: ref.accountRouterParams,
        );
      },
      style: TextButton.styleFrom(
        minimumSize: const Size(0, 48),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        visualDensity: VisualDensity.standard,
      ),
      child: Row(
        children: [
          const Icon(Icons.campaign_rounded),
          const SizedBox(width: 8),
          Expanded(
            flex: isCompact ? 1 : 0,
            child: const Text("Announcements"),
          ),
          if (unreadCount != null && unreadCount > 0) ...[
            const SizedBox(width: 8),
            Badge(label: Text(unreadCount.toString())),
          ],
        ],
      ),
    );
  }
}

@Riverpod(
  keepAlive: true,
  dependencies: [currentAccount, FollowRequestsService],
)
Future<(int count, bool hasMore)?> _followRequestCount(
  _FollowRequestCountRef ref,
) async {
  final key = ref.watch(currentAccountProvider)!.key;
  final service = ref.watch(followRequestsServiceProvider(key));
  final value = service.valueOrNull;
  if (value == null) return null;
  return (value.items.length, value.canPaginateFurther);
}

@Riverpod(
  keepAlive: true,
  dependencies: [currentAccount, AnnouncementsService],
)
Future<int> _unreadAnnouncementCount(
  _UnreadAnnouncementCountRef ref,
) async {
  final key = ref.watch(currentAccountProvider)!.key;
  final service = ref.watch(announcementsServiceProvider(key));
  final value = service.valueOrNull;
  if (value == null) return 0;
  return value.where((e) => e.isUnread == true).length;
}

class _FollowRequestsButton extends ConsumerWidget {
  // I'm kinda perplexed why there isn't a way to make one widget fill the
  // available space only if the space is constrained.
  final bool expand;

  const _FollowRequestsButton({this.expand = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgeText = getText(ref);
    return TextButton(
      onPressed: () {
        context.pushNamed(
          "follow-requests",
          pathParameters: ref.accountRouterParams,
        );
      },
      style: TextButton.styleFrom(
        minimumSize: const Size(0, 48),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        visualDensity: VisualDensity.standard,
      ),
      child: Row(
        children: [
          const Icon(Icons.person_add_rounded),
          const SizedBox(width: 8),
          Expanded(
            flex: expand ? 1 : 0,
            child: const Text("Follow Requests"),
          ),
          if (badgeText != null) ...[
            const SizedBox(width: 8),
            Badge(label: Text(badgeText)),
          ],
        ],
      ),
    );
  }

  String? getText(WidgetRef ref) {
    final state = ref.watch(_followRequestCountProvider).valueOrNull;
    if (state == null || state.$1 <= 0) return null;
    final buffer = StringBuffer(state.$1.toString());
    if (state.$2) buffer.write("+");
    return buffer.toString();
  }
}
