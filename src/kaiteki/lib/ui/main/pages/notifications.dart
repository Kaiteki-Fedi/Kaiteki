import "package:animations/animations.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart" hide Notification;
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/notifications.dart";
import "package:kaiteki/theming/kaiteki/colors.dart";
import "package:kaiteki/ui/animation_functions.dart" as animations;
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/error_landing_widget.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
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
                          child: ReadNotificationsFloatingActionButton(),
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
    return ListView.separated(
      itemBuilder: (context, i) => NotificationWidget(data.elementAt(i)),
      separatorBuilder: (context, _) => const Divider(),
      itemCount: data.length,
      padding: addFABPadding
          ? const EdgeInsets.only(bottom: kFloatingActionButtonMargin * 2 + 56)
          : null,
    );
  }
}

class ReadNotificationsFloatingActionButton extends ConsumerWidget {
  const ReadNotificationsFloatingActionButton({super.key});

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
        label: "Show details",
        onPressed: () => context.showExceptionDialog((error, stackTrace)),
      ),
    );
    messenger.showSnackBar(snackBar);
  }
}

enum Corner {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class CornerPainter extends CustomPainter {
  final Paint cornerPaint;
  final Corner corner;

  const CornerPainter(this.corner, this.cornerPaint);

  @override
  void paint(Canvas canvas, Size size) {
    final points = switch (corner) {
      Corner.topLeft => [
          Offset.zero,
          Offset(size.width, 0),
          Offset(0, size.height),
        ],
      Corner.topRight => [
          Offset.zero,
          Offset(size.width, 0),
          Offset(size.width, size.height),
        ],
      Corner.bottomLeft => [
          Offset.zero,
          Offset(0, size.height),
          Offset(size.width, 0),
        ],
      Corner.bottomRight => [
          Offset(size.width, 0),
          Offset(size.width, size.height),
          Offset(0, size.height),
        ],
    };

    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CornerPainter oldDelegate) {
    return oldDelegate.cornerPaint != cornerPaint &&
        oldDelegate.corner != corner;
  }
}

class NotificationWidget extends ConsumerWidget {
  final Notification notification;

  const NotificationWidget(this.notification, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inheritedTextStyle = DefaultTextStyle.of(context).style;
    final color = _getColor(context);
    final icon = _getNotificationIcon(notification.type);
    final post = notification.post;
    final user = notification.user;
    final unreadPaint = Paint()..color = Theme.of(context).colorScheme.error;
    return InkWell(
      onTap: () => _onTap(context, ref),
      child: Stack(
        children: [
          if (notification.unread == true)
            Positioned(
              top: 0,
              right: 0,
              width: 8,
              height: 8,
              child: CustomPaint(
                painter: CornerPainter(Corner.topRight, unreadPaint),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    if (user != null)
                      AvatarWidget(user, size: 40)
                    else
                      const SizedBox(width: 40),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.background,
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(
                            icon ?? Icons.notifications_rounded,
                            size: 12,
                            color: ThemeData.estimateBrightnessForColor(color)
                                .inverted
                                .getColor(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  if (user != null)
                                    TextSpan(
                                      children: [
                                        user.renderDisplayName(context, ref),
                                        if (notification is GroupedNotification)
                                          TextSpan(
                                            text:
                                                " and ${(notification as GroupedNotification).notifications.length - 1} others",
                                          ),
                                      ],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  TextSpan(
                                    text: _getTitle(context, notification.type),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Tooltip(
                            message: notification.createdAt.toString(),
                            child: Text(
                              DateTime.now()
                                  .difference(notification.createdAt)
                                  .toStringHuman(context: context),
                              style: TextStyle(
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      if (post != null && post.content != null)
                        Text.rich(
                          post.renderContent(context, ref),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: inheritedTextStyle.copyWith(
                            color: inheritedTextStyle.color?.withOpacity(.5),
                          ),
                        ),
                      // if (notification.type == NotificationType.followRequest)
                      //   Row(
                      //     children: [
                      //       OutlinedButton.icon(
                      //         onPressed: null,
                      //         icon: const Icon(Icons.check_rounded),
                      //         label: const Text("Accept"),
                      //       ),
                      //       const SizedBox(width: 6),
                      //       TextButton.icon(
                      //         onPressed: null,
                      //         icon: const Icon(Icons.close_rounded),
                      //         label: const Text("Reject"),
                      //       ),
                      //     ],
                      //   ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData? _getNotificationIcon(NotificationType type) {
    return switch (type) {
      NotificationType.liked => Icons.star_rounded,
      NotificationType.repeated => Icons.repeat_rounded,
      NotificationType.mentioned => Icons.alternate_email_rounded,
      NotificationType.followed => Icons.add_rounded,
      NotificationType.followRequest => Icons.person_outline_rounded,
      NotificationType.reacted => Icons.emoji_emotions_rounded,
      NotificationType.groupInvite => Icons.group_add_rounded,
      NotificationType.pollEnded => Icons.poll_rounded,
      NotificationType.quoted => Icons.format_quote_rounded,
      NotificationType.replied => Icons.reply_rounded,
      NotificationType.updated => Icons.edit_rounded,
      NotificationType.reported => Icons.report_rounded,
      NotificationType.signedUp => Icons.person_add_rounded,
      NotificationType.newPost => Icons.post_add_rounded,
      NotificationType.userMigrated => Icons.swap_horiz_rounded,
      NotificationType.unsupported => Icons.question_mark
    };
  }

  Color _getColor(BuildContext context) {
    final theme = Theme.of(context);
    final ktkColors = theme.ktkColors;
    final defaults = DefaultKaitekiColors(context);

    final colorScheme = theme.colorScheme;

    switch (notification.type) {
      case NotificationType.liked:
        return ktkColors?.favoriteColor ?? defaults.favoriteColor;

      case NotificationType.repeated:
        return ktkColors?.repeatColor ?? defaults.repeatColor;

      case NotificationType.reported:
        return colorScheme.error;

      case NotificationType.reacted:
      case NotificationType.updated:
      case NotificationType.newPost:
        return colorScheme.secondary;

      case NotificationType.quoted:
      case NotificationType.replied:
      case NotificationType.mentioned:
      case NotificationType.pollEnded:
        return colorScheme.primary;

      case NotificationType.followed:
      case NotificationType.followRequest:
      case NotificationType.groupInvite:
      case NotificationType.signedUp:
      case NotificationType.userMigrated:
        return colorScheme.tertiary;

      case NotificationType.unsupported:
        return colorScheme.outline;
    }
  }

  String _getTitle(BuildContext context, NotificationType type) {
    return switch (type) {
      NotificationType.liked => " favorited your post",
      NotificationType.repeated => " repeated your post",
      NotificationType.reacted => " reacted to your post",
      NotificationType.followed => " followed you",
      NotificationType.mentioned => " mentioned you",
      NotificationType.followRequest => " wants to follow you",
      NotificationType.groupInvite => " invited you to a group",
      NotificationType.pollEnded => "'s poll has ended",
      NotificationType.quoted => " quoted you",
      NotificationType.replied => " replied to you",
      NotificationType.updated => " updated their post",
      NotificationType.reported => "New report",
      NotificationType.signedUp => " has joined the instance",
      NotificationType.newPost => " made a new post",
      NotificationType.userMigrated => " migrated to a new account",
      NotificationType.unsupported => "Unsupported notification"
    };
  }

  void _onTap(BuildContext context, WidgetRef ref) {
    if (notification.post != null) {
      final accountKey = ref.read(currentAccountProvider)!.key;
      context.pushNamed(
        "post",
        extra: notification.post,
        pathParameters: {
          ...accountKey.routerParams,
          "id": notification.post!.id,
        },
      );
      return;
    }

    if (notification.user != null) {
      final accountKey = ref.read(currentAccountProvider)!.key;
      context.pushNamed(
        "user",
        extra: notification.user,
        pathParameters: {
          ...accountKey.routerParams,
          "id": notification.user!.id,
        },
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "This notification doesn't have a post or user attached to it.",
        ),
      ),
    );
  }
}
