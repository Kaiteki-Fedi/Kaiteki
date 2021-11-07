// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      id: json['id'] as String,
      type: json['type'] as String,
      pleroma: json['pleroma'] == null
          ? null
          : Notification.fromJson(json['pleroma'] as Map<String, dynamic>),
      status: json['status'] == null
          ? null
          : Status.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'account': instance.account,
      'created_at': instance.createdAt.toIso8601String(),
      'id': instance.id,
      'pleroma': instance.pleroma,
      'status': instance.status,
      'type': instance.type,
    };
