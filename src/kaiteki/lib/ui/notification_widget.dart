import "package:flutter/material.dart" hide Notification;
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/theming/kaiteki/colors.dart";
import "package:kaiteki/ui/shared/corner_painter.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";

class NotificationWidget extends ConsumerWidget {
  final Notification notification;

  const NotificationWidget(this.notification, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _getColor(context);
    final icon = _getNotificationIcon(notification.type);
    final post = notification.post;
    final user = notification.user;
    final unreadPaint = Paint()..color = Theme.of(context).colorScheme.error;
    final relativeTime = DateTime.now()
        .difference(notification.createdAt)
        .toStringHuman(context: context);
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SizedBox.square(
                    dimension: 24,
                    child: Icon(
                      icon ?? Icons.notifications_rounded,
                      size: 14,
                      color: ThemeData.estimateBrightnessForColor(color)
                          .inverted
                          .getColor(),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RepaintBoundary(
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
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              TextSpan(
                                text: _getTitle(context, notification.type),
                              ),
                              TextSpan(
                                text: " • $relativeTime",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              )
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (post != null && post.content != null)
                        Text.rich(
                          post.renderContent(context, ref),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
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
                const SizedBox(width: 14),
                Stack(
                  children: [
                    if (user != null)
                      AvatarWidget(user, size: 40)
                    else
                      const SizedBox(width: 40),
                  ],
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
