import "package:animations/animations.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart" hide Notification;
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/notifications.dart";
import "package:kaiteki/ui/animation_functions.dart" as animations;
import "package:kaiteki/ui/notification_widget.dart";
import "package:kaiteki/ui/shared/common.dart";
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
      onRefresh: () => ref.read(notifications.notifier).refresh(),
      child: PageTransitionSwitcher(
        transitionBuilder: animations.fadeThrough,
        child: ref.watch(notifications).when(
              data: (data) {
                final hasUnread = data.any((e) => e.unread == true);
                final grouped = groupNotifications(data);
                return Stack(
                  children: [
                    _buildList(grouped, true),
                    if (hasUnread)
                      const Positioned(
                        bottom: kFloatingActionButtonMargin,
                        left: kFloatingActionButtonMargin,
                        right: kFloatingActionButtonMargin,
                        child: Align(
                          child: _MarkAsReadFAB(),
                        ),
                      ),
                  ],
                );
              },
              error: (e, s) => Center(child: ErrorLandingWidget((e, s))),
              loading: () => centeredCircularProgressIndicator,
            ),
      ),
    );
  }

  List<Notification> groupNotifications(List<Notification> ungrouped) {
    final groups = ungrouped.groupBy((e) {
      String? followRequestValue;

      if (e.type == NotificationType.followRequest) {
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

          if (notifications.length <= 2) return kv.value.toList();

          return [GroupedNotification(notifications.toList())];
        })
        .flattened
        .toList();
  }

  Widget _buildList(Iterable<Notification> data, [bool addFABPadding = false]) {
    // TODO(Craftplacer): Make notifications infinitely scrollable

    const fabPadding =
        EdgeInsets.only(bottom: kFloatingActionButtonMargin * 2 + 56);

    return ListView.separated(
        itemBuilder: (context, i) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: NotificationWidget(data.elementAt(i)),
          );
        },
        separatorBuilder: (context, _) => const SizedBox(height: 8),
        itemCount: data.length,
        padding: const EdgeInsets.all(16)
            .add(addFABPadding ? fabPadding : EdgeInsets.zero));
  }
}

class _MarkAsReadFAB extends ConsumerWidget {
  const _MarkAsReadFAB({super.key});

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
