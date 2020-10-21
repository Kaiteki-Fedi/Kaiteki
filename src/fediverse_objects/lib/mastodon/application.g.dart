// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonApplication _$MastodonApplicationFromJson(Map<String, dynamic> json) {
  return MastodonApplication(
    clientId: json['client_id'] as String,
    clientSecret: json['client_secret'] as String,
    id: json['id'] as String,
    name: json['name'] as String,
    vapidKey: json['vapid_key'] as String,
    website: json['website'] as String,
  );
}
