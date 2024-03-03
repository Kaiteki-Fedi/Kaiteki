import "dart:async";
import "dart:io";
import "dart:ui";

import "package:flutter/foundation.dart";
import "package:flutter/painting.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:http/http.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/pagination_state.dart";
import "package:kaiteki/preferences/app_experiment.dart";
import "package:kaiteki/utils/image.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:logging/logging.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "notifications.g.dart";

@Riverpod(keepAlive: true)
class NotificationService extends _$NotificationService {
  static final _logger = Logger("NotificationService");
  StreamSubscription<AuxiliaryEvent>? _stream;

  late NotificationSupport _backend;

  Future<void> markAllAsRead() async {
    state = const AsyncLoading();
    try {
      await _backend.markAllNotificationsAsRead();
    } catch (e, s) {
      _logger.warning("Failed to mark all notifications as read", e, s);
      rethrow;
    } finally {
      state = await AsyncValue.guard(() async {
        final notifications = await _backend.getNotifications();
        return PaginationState(
          notifications,
          canPaginateFurther: notifications.isNotEmpty,
        );
      });
    }
  }

  @override
  FutureOr<PaginationState<Notification>> build(AccountKey key) async {
    final account = ref
        .read(accountManagerProvider)
        .accounts
        .firstWhere((a) => a.key == key);
    _backend = account.adapter as NotificationSupport;

    ref.onDispose(() => _stream?.cancel());

    if (_backend is StreamSupport) {
      final streaming = _backend as StreamSupport;
      _stream = streaming.listenToAuxiliaryEvents().listen((event) {
        final previousState = state.valueOrNull;

        if (previousState == null) return;

        switch (event) {
          case NotificationEvent():
            state = AsyncValue.data(
              PaginationState(
                [event.notification, ...previousState.items],
                canPaginateFurther: previousState.canPaginateFurther,
              ),
            );
        }
      });
    }

    final notifications = await _backend.getNotifications();
    return PaginationState(
      notifications,
      canPaginateFurther: notifications.isNotEmpty,
    );
  }

  Future<void> loadMore() async {
    if (state is! AsyncData) return;

    final data = state.value!.items;

    state = await AsyncValue.guard(() async {
      final newNotifications = await _backend.getNotifications(
        untilId: data.lastOrNull?.id,
      );
      return PaginationState(
        data + newNotifications,
        canPaginateFurther: newNotifications.isNotEmpty,
      );
    });
  }
}

class NativeNotificationPoster {
  Future<void> sendNotification(Notification notification) async {
    const initializationSettingsLinux = LinuxInitializationSettings(
      defaultActionName: "Open notification",
    );
    const initializationSettings = InitializationSettings(
      linux: initializationSettingsLinux,
      android: AndroidInitializationSettings("ic_kaiteki"),
    );
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(initializationSettings);

    ByteArrayAndroidBitmap? bitmap;

    if (notification.user != null) {
      final response = await get(notification.user!.avatarUrl!);
      var image = await decodeImageFromList(response.bodyBytes);
      image = await resize(image, 64, 64);
      bitmap = ByteArrayAndroidBitmap(
        await toUint8List(image, ImageByteFormat.png),
      );
    }

    await plugin.show(
      notification.createdAt.hashCode,
      notification.type.toString(),
      "",
      NotificationDetails(
        android: AndroidNotificationDetails(
          "@Craftplacer@pl.craftplacer.moe/${notification.type.name}",
          "@Craftplacer@pl.craftlpacer.moe/${notification.type.name}",
          largeIcon: bitmap,
          category: AndroidNotificationCategory.social,
          actions: [],
        ),
        linux: await getLinuxDetails(notification),
      ),
    );
  }

  Future<LinuxNotificationDetails?> getLinuxDetails(
    Notification notification,
  ) async {
    if (kIsWeb || !Platform.isLinux) return null;

    LinuxNotificationIcon? icon;

    if (notification.user != null) {
      final response = await get(notification.user!.avatarUrl!);
      var image = await decodeImageFromList(response.bodyBytes);
      image = await resize(image, 64, 64);
      icon = ByteDataLinuxIcon(
        LinuxRawIconData(
          data: await toUint8List(image),
          height: image.height,
          width: image.width,
          channels: 4,
          // The icon has an alpha channel
          hasAlpha: true,
        ),
      );
    }

    return LinuxNotificationDetails(
      actions: [],
      icon: icon,
    );
  }
}
