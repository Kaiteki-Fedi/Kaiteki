// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonNotification _$MastodonNotificationFromJson(Map<String, dynamic> json) {
  return MastodonNotification(
    account: MastodonAccount.fromJson(json['account'] as Map<String, dynamic>),
    createdAt: DateTime.parse(json['created_at'] as String),
    id: json['id'] as String,
    type: json['type'] as String,
    pleroma: json['pleroma'] == null
        ? null
        : PleromaNotification.fromJson(json['pleroma'] as Map<String, dynamic>),
    status: json['status'] == null
        ? null
        : MastodonStatus.fromJson(json['status'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MastodonNotificationToJson(
        MastodonNotification instance) =>
    <String, dynamic>{
      'account': instance.account,
      'created_at': instance.createdAt.toIso8601String(),
      'id': instance.id,
      'pleroma': instance.pleroma,
      'status': instance.status,
      'type': instance.type,
    };
