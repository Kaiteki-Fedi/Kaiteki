import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/notification_support.dart';
import 'package:kaiteki/fediverse/model/notification.dart';
import 'package:kaiteki/model/auth/account_key.dart';
import 'package:kaiteki/utils/image.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications.g.dart';

@Riverpod(keepAlive: true)
class NotificationService extends _$NotificationService {
  late NotificationSupport _backend;

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_backend.getNotifications);
  }

  Future<void> markAllAsRead() async {
    state = const AsyncLoading();
    try {
      await _backend.markAllNotificationsAsRead();
    } finally {
      state = await AsyncValue.guard(_backend.getNotifications);
    }
  }

  @override
  FutureOr<List<Notification>> build(AccountKey key) async {
    final manager = ref.read(accountManagerProvider);
    final account = manager.accounts.firstWhere((a) => a.key == key);
    _backend = account.adapter as NotificationSupport;
    return await _backend.getNotifications();
  }
}

class NativeNotificationPoster {
  Future<void> sendNotification(Notification notification) async {
    const initializationSettingsLinux = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );
    const initializationSettings = InitializationSettings(
      linux: initializationSettingsLinux,
      android: AndroidInitializationSettings("ic_kaiteki"),
    );
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(initializationSettings);

    ByteArrayAndroidBitmap? bitmap;

    if (notification.user != null) {
      final response = await get(Uri.parse(notification.user!.avatarUrl!));
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
      final response = await get(Uri.parse(notification.user!.avatarUrl!));
      var image = await decodeImageFromList(response.bodyBytes);
      image = await resize(image, 64, 64);
      icon = ByteDataLinuxIcon(
        LinuxRawIconData(
          data: await toUint8List(image),
          height: image.height,
          width: image.width,
          channels: 4, // The icon has an alpha channel
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
