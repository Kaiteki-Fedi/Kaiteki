// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonNotification _$MastodonNotificationFromJson(Map<String, dynamic> json) {
  return MastodonNotification(
    account: json['account'] == null
        ? null
        : MastodonAccount.fromJson(json['account'] as Map<String, dynamic>),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    id: json['id'] as String,
    pleroma: json['pleroma'] == null
        ? null
        : PleromaNotification.fromJson(json['pleroma'] as Map<String, dynamic>),
    status: json['status'] == null
        ? null
        : MastodonStatus.fromJson(json['status'] as Map<String, dynamic>),
    type: json['type'] as String,
  );
}
