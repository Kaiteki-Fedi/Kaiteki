import "package:flutter/material.dart" hide Notification;
import "package:fpdart/fpdart.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/theming/kaiteki/colors.dart";
import "package:kaiteki/ui/shared/corner_painter.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";

class NotificationWidget extends ConsumerStatefulWidget {
  final Notification notification;

  const NotificationWidget(this.notification, {super.key});

  @override
  ConsumerState<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends ConsumerState<NotificationWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final color = _getColor(context);
    final notification = widget.notification;
    final icon = _getNotificationIcon(notification.type);
    final post = notification.post;
    final user = notification.user;
    final unreadPaint = Paint()..color = Theme.of(context).colorScheme.error;

    final canShowContent = post != null && post.content?.isNotEmpty == true;
    final showContent = canShowContent && !_expanded;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
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
                                  buildTitle(context, notification),
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                              ),
                              if (showContent) ...[
                                const SizedBox(height: 4),
                                Text.rich(
                                  post.renderContent(context, ref),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        if (user != null &&
                            !(notification is GroupedNotification && _expanded))
                          AvatarWidget(
                            user,
                            size: 40,
                            onTap: () => context.showUser(user, ref),
                          ),
                        if (notification is GroupedNotification ||
                            canShowContent) ...[
                          const SizedBox(width: 16),
                          _ExpandIndicator(
                            expanded: _expanded,
                            text: notification
                                .safeCast<GroupedNotification>()
                                .nullTransform(
                                  (e) =>
                                      Text(e.notifications.length.toString()),
                                ),
                            onTap: () => setState(() => _expanded = !_expanded),
                          ),
                        ],
                      ],
                    ),
                    if (canShowContent &&
                        _expanded &&
                        notification is! GroupedNotification) ...[
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 38.0),
                        child: Text.rich(
                          post.renderContent(context, ref),
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 26.0),
                        child: Wrap(
                          children: [
                            TextButton(
                              onPressed: () {
                                context.pushNamed(
                                  "compose",
                                  pathParameters: ref.accountRouterParams,
                                  extra: post,
                                );
                              },
                              child: Text(context.l10n.replyButtonLabel),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_expanded && notification is GroupedNotification) ...[
          const Divider(),
          ...notification.notifications
              .map<Widget>(NotificationWidget.new)
              .intersperse(const Divider()),
        ],
      ],
    );
  }

  TextSpan buildTitle(BuildContext context, Notification notification) {
    final user = notification.user;
    final relativeTime = DateTime.now()
        .difference(notification.createdAt)
        .toStringHuman(context: context);

    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    final titleSmall = Theme.of(context).textTheme.titleSmall;

    return TextSpan(
      children: [
        if (user != null)
          TextSpan(
            children: [
              user.renderDisplayName(context, ref),
              if (notification is GroupedNotification)
                TextSpan(
                  text: " and ${notification.notifications.length - 1} others",
                ),
            ],
            style: titleSmall,
          ),
        TextSpan(
          text: _getTitle(context, notification.type),
        ),
        TextSpan(
          text: " • $relativeTime",
          style: bodySmall?.copyWith(color: onSurfaceVariant),
        ),
      ],
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

    switch (widget.notification.type) {
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
    if (widget.notification.post != null) {
      final accountKey = ref.read(currentAccountProvider)!.key;
      context.pushNamed(
        "post",
        extra: widget.notification.post,
        pathParameters: {
          ...accountKey.routerParams,
          "id": widget.notification.post!.id,
        },
      );
      return;
    }

    if (widget.notification.user != null) {
      final accountKey = ref.read(currentAccountProvider)!.key;
      context.pushNamed(
        "user",
        extra: widget.notification.user,
        pathParameters: {
          ...accountKey.routerParams,
          "id": widget.notification.user!.id,
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

class _ExpandIndicator extends StatelessWidget {
  final Widget? text;
  final VoidCallback? onTap;
  final bool expanded;

  const _ExpandIndicator({
    this.text,
    this.onTap,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const StadiumBorder(),
      color: Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 24,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                if (text != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: text,
                  ),
                  const SizedBox(width: 2),
                ],
                Icon(
                  expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
