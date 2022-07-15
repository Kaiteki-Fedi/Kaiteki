// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credits_screen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditsItem _$CreditsItemFromJson(Map<String, dynamic> json) => CreditsItem(
      name: json['name'] as String,
      url: json['url'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$CreditsItemToJson(CreditsItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'roles': instance.roles,
    };
