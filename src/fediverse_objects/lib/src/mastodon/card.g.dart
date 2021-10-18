// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Card _$CardFromJson(Map<String, dynamic> json) {
  return Card(
    json['description'] as String,
    json['image'] as String?,
    p.Card.fromJson(json['pleroma'] as Map<String, dynamic>),
    json['provider_name'] as String,
    json['provider_url'] as String,
    json['title'] as String,
    json['type'] as String,
    json['url'] as String,
  );
}

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'description': instance.description,
      'image': instance.image,
      'pleroma': instance.pleroma,
      'provider_name': instance.providerName,
      'provider_url': instance.providerUrl,
      'title': instance.title,
      'type': instance.type,
      'url': instance.url,
    };
