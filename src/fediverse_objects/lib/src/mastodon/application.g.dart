// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonApplication _$MastodonApplicationFromJson(Map<String, dynamic> json) {
  return MastodonApplication(
    name: json['name'] as String,
    website: json['website'] as String?,
    vapidKey: json['vapid_key'] as String?,
    clientId: json['client_id'] as String?,
    clientSecret: json['client_secret'] as String?,
    id: json['id'] as String?,
  );
}

Map<String, dynamic> _$MastodonApplicationToJson(
        MastodonApplication instance) =>
    <String, dynamic>{
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
      'id': instance.id,
      'name': instance.name,
      'vapid_key': instance.vapidKey,
      'website': instance.website,
    };
