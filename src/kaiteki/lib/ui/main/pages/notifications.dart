import 'package:animations/animations.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/notification_support.dart';
import 'package:kaiteki/fediverse/model/notification.dart';
import 'package:kaiteki/ui/animation_functions.dart' as animations;
import 'package:kaiteki/ui/shared/conversation_screen.dart';
import 'package:kaiteki/ui/shared/error_landing_widget.dart';
import 'package:kaiteki/ui/shared/icon_landing_widget.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:mdi/mdi.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final adapter = ref.watch(adapterProvider);

    if (adapter is! NotificationSupport) {
      return ErrorLandingWidget(error: UnimplementedError());
    }

    final nAdapter = adapter as NotificationSupport;

    return FutureBuilder<Iterable<Notification>>(
      future: nAdapter.getNotifications(),
      builder: (context, snapshot) {
        return PageTransitionSwitcher(
          transitionBuilder: animations.fadeThrough,
          child: _buildBody(context, snapshot),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncSnapshot<Iterable<Notification>> snapshot,
  ) {
    if (snapshot.hasError) {
      return const IconLandingWidget(
        icon: Icon(Mdi.bellCancel),
        text: Text("Failed to fetch notifications"),
      );
    } else if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      itemBuilder: (context, i) {
        final notification = snapshot.data!.elementAt(i);
        return NotificationWidget(notification);
      },
      separatorBuilder: (context, _) => const Divider(height: 2),
      itemCount: snapshot.data!.length,
    );
  }
}

class NotificationWidget extends ConsumerWidget {
  final Notification notification;

  static final _icons = <NotificationType, IconData>{
    NotificationType.liked: Mdi.star,
    NotificationType.repeated: Mdi.repeat,
    NotificationType.mentioned: Mdi.at,
    NotificationType.followed: Mdi.accountPlus,
    NotificationType.reacted: Mdi.emoticon,
  };

  static final _colors = <NotificationType, Color>{
    NotificationType.liked: Colors.amber,
    NotificationType.repeated: Colors.green,
    NotificationType.mentioned: Colors.blue,
    NotificationType.followed: Colors.blue,
    NotificationType.reacted: Colors.purple,
  };

  const NotificationWidget(this.notification, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ConversationScreen(notification.post!),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Badge(
              position: BadgePosition.bottomEnd(bottom: 0, end: 0),
              badgeContent: Icon(_icons[notification.type], size: 16),
              badgeColor: _colors[notification.type] ?? Colors.grey,
              padding: const EdgeInsets.all(2.0),
              child: AvatarWidget(notification.user!),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          children: [
                            notification.user!.renderDisplayName(context, ref)
                          ],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: _getTitle(context, notification.type)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text.rich(
                      notification.post!.renderContent(context, ref),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
    }
  }
}
