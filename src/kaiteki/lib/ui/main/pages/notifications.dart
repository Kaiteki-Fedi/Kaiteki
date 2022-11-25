import 'package:animations/animations.dart';
import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:go_router/go_router.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/notification_support.dart';
import 'package:kaiteki/fediverse/model/notification.dart';
import 'package:kaiteki/fediverse/services/notifications.dart';
import 'package:kaiteki/theming/kaiteki/colors.dart';
import 'package:kaiteki/ui/animation_functions.dart' as animations;
import 'package:kaiteki/ui/rounded_underline_tab_indicator.dart';
import 'package:kaiteki/ui/shared/error_landing_widget.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider).current;
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

    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        floatHeaderSlivers: true,
        dragStartBehavior: DragStartBehavior.down,
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(
            child: Column(
              children: [
                TabBar(
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Theme.of(context).disabledColor,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: RoundedUnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    radius: const Radius.circular(2),
                  ),
                  // TODO(Craftplacer): Localize
                  tabs: const [
                    Tab(text: "Unread"),
                    Tab(text: "Read"),
                  ],
                ),
                const Divider(height: 1),
              ],
            ),
          ),
        ],
        body: PageTransitionSwitcher(
          transitionBuilder: animations.fadeThrough,
          child: ref.watch(notifications).when(
                data: (data) =>
                    _buildBody(data, ref.read(notifications.notifier)),
                error: (error, stackTrace) => Center(
                  child: ErrorLandingWidget(
                    error: error,
                    stackTrace: stackTrace,
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
        ),
      ),
    );
  }

  Widget _buildBody(List<Notification> data, NotificationService service) {
    final unread = data.where((n) => n.unread != false);
    final unreadLength = unread.length;

    final read = data.where((n) => n.unread == false);
    final readLength = read.length;

    return Material(
      child: TabBarView(
        children: [
          if (unreadLength < 1)
            const Center(
              child: IconLandingWidget(
                icon: Icon(Icons.notifications_active_rounded),
                text: Text("New notifications will appear here"),
              ),
            )
          else
            Stack(
              children: [
                _buildList(unread, true),
                Positioned(
                  bottom: kFloatingActionButtonMargin,
                  left: kFloatingActionButtonMargin,
                  right: kFloatingActionButtonMargin,
                  child: Align(
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        final messenger = ScaffoldMessenger.of(context);
                        service.markAllAsRead().onError((error, stackTrace) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Failed to mark notification as read",
                              ),
                              action: SnackBarAction(
                                label: "Show details",
                                onPressed: () => context.showExceptionDialog(
                                  error,
                                  stackTrace,
                                ),
                              ),
                            ),
                          );
                        });
                      },
                      label: const Text("Mark all as read"),
                      icon: const Icon(Icons.done_all_rounded),
                    ),
                  ),
                ),
              ],
            ),
          if (readLength < 1)
            const Center(
              child: IconLandingWidget(
                icon: Icon(Icons.notifications_none_rounded),
                text: Text("Read notifications will appear here"),
              ),
            )
          else
            _buildList(read),
        ],
      ),
    );
  }

  Widget _buildList(Iterable<Notification> data, [bool addFABPadding = false]) {
    // TODO(Craftplacer): Make notifications infinitely scrollable
    return ListView.separated(
      itemBuilder: (context, i) => NotificationWidget(data.elementAt(i)),
      separatorBuilder: (context, _) => const Divider(height: 2),
      itemCount: data.length,
      padding: addFABPadding
          ? const EdgeInsets.only(bottom: kFloatingActionButtonMargin * 2 + 56)
          : null,
    );
  }
}

class NotificationWidget extends ConsumerWidget {
  final Notification notification;

  static final _icons = <NotificationType, IconData>{
    NotificationType.liked: Icons.star_rounded,
    NotificationType.repeated: Icons.repeat_rounded,
    NotificationType.mentioned: Icons.alternate_email_rounded,
    NotificationType.followed: Icons.person_add_rounded,
    NotificationType.followRequest: Icons.person_add_rounded,
    NotificationType.reacted: Icons.emoji_emotions_rounded,
  };

  const NotificationWidget(this.notification, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inheritedTextStyle = DefaultTextStyle.of(context).style;
    final color = _getColor(context);
    final icon = _icons[notification.type];
    final post = notification.post;
    return InkWell(
      onTap: () => _onTap(context, ref),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Badge(
              position: BadgePosition.bottomEnd(bottom: 0, end: 0),
              badgeContent: Icon(
                icon ?? Icons.notifications_rounded,
                size: 12,
                color: ThemeData.estimateBrightnessForColor(color)
                    .inverted
                    .getColor(),
              ),
              badgeColor: color,
              padding: const EdgeInsets.all(3.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.background,
                width: 2,
                strokeAlign: StrokeAlign.outside,
              ),
              showBadge: icon != null,
              toAnimate: false,
              child: AvatarWidget(
                notification.user!,
                size: 40,
              ),
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
                              TextSpan(
                                children: [
                                  notification.user!
                                      .renderDisplayName(context, ref)
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
                        ),
                      ),
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
                  if (notification.type == NotificationType.followRequest)
                    Row(
                      children: [
                        // TODO(Craftplacer): add following implementation
                        OutlinedButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.check_rounded),
                          label: const Text("Accept"),
                        ),
                        const SizedBox(width: 6),
                        TextButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.close_rounded),
                          label: const Text("Reject"),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(BuildContext context) {
    final colors = Theme.of(context).ktkColors;

    switch (notification.type) {
      case NotificationType.liked:
        return colors!.favoriteColor;
      case NotificationType.repeated:
        return colors!.repeatColor;
      default:
        return Colors.blue.shade400;
    }
  }

  String _getTitle(BuildContext context, NotificationType type) {
    switch (type) {
      case NotificationType.liked:
        return " favorited your post";
      case NotificationType.repeated:
        return " repeated your post";
      case NotificationType.reacted:
        return " reacted to your post";
      case NotificationType.followed:
        return " followed you";
      case NotificationType.mentioned:
        return " mentioned you";
      case NotificationType.followRequest:
        return " wants to follow you";

      case NotificationType.groupInvite:
        return " invited you to a group";
      case NotificationType.pollEnded:
        return "Poll has ended";
      case NotificationType.quoted:
        return " quoted you";
      case NotificationType.replied:
        return " replied to you";
    }
  }

  void _onTap(BuildContext context, WidgetRef ref) {
    switch (notification.type) {
      case NotificationType.liked:
      case NotificationType.repeated:
      case NotificationType.reacted:
      case NotificationType.mentioned:
        assert(
          notification.post != null,
          "Tried to open a notification without a post attached to it",
        );
        final account = ref.read(accountProvider).current;
        context.push(
          "/@${account.key.username}@${account.key.host}/posts/${notification.post!.id}",
          extra: notification.post,
        );
        break;
      case NotificationType.followed:
      case NotificationType.followRequest:
        assert(
          notification.user != null,
          "Tried to open a follow notification without a user attached to it",
        );
        context.showUser(notification.user!, ref);
        break;
    }
  }
}
