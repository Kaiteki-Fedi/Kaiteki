part of "tab.dart";

class _NotificationsMainScreenTab extends MainScreenTab {
  const _NotificationsMainScreenTab();

  @override
  Widget? buildFab(BuildContext context, WidgetRef ref) {
    final accountKey = ref.read(currentAccountProvider)!.key;
    final notifications = notificationServiceProvider(accountKey);
    final hasUnread = ref
        .watch(notifications)
        .valueOrNull
        ?.items
        .any((e) => e.unread == true);

    if (hasUnread != true) return null;

    return FloatingActionButton.extended(
      icon: const Icon(Icons.clear_all_rounded),
      label: const Text("Mark all as read"),
      heroTag: "aaa",
      onPressed: () {
        final accountKey = ref.read(currentAccountProvider)!.key;
        ref
            .read(notificationServiceProvider(accountKey).notifier)
            .markAllAsRead();
      },
    );
  }

  @override
  int? fetchUnreadCount(WidgetRef ref) {
    final accountKey = ref.read(currentAccountProvider)!.key;
    final notifications = notificationServiceProvider(accountKey);
    return ref
        .watch(notifications)
        .valueOrNull
        ?.items
        .where((e) => e.unread == true)
        .length;
  }

  @override
  FloatingActionButtonLocation? get fabLocation =>
      FloatingActionButtonLocation.centerFloat;

  @override
  bool isAvailable(BackendAdapter adapter) => adapter is NotificationSupport;
}
