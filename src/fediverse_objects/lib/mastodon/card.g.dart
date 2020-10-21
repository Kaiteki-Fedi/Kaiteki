// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MastodonCard _$MastodonCardFromJson(Map<String, dynamic> json) {
  return MastodonCard(
    json['description'] as String,
    json['image'] as String,
    json['pleroma'] == null
        ? null
        : PleromaCard.fromJson(json['pleroma'] as Map<String, dynamic>),
    json['provider_name'] as String,
    json['provider_url'] as String,
    json['title'] as String,
    json['type'] as String,
    json['url'] as String,
  );
}
