import 'dart:async';

import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/notification_support.dart';
import 'package:kaiteki/fediverse/model/notification.dart';
import 'package:kaiteki/model/account_key.dart';
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
    final manager = ref.read(accountProvider);
    final account = manager.accounts.firstWhere((a) => a.key == key);
    _backend = account.adapter as NotificationSupport;
    return await _backend.getNotifications();
  }
}
