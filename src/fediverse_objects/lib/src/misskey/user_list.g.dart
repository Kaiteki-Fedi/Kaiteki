// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyUserList _$MisskeyUserListFromJson(Map<String, dynamic> json) {
  return MisskeyUserList(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    name: json['name'] as String,
    userIds: (json['userIds'] as List)?.map((e) => e as String),
  );
}

Map<String, dynamic> _$MisskeyUserListToJson(MisskeyUserList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'name': instance.name,
      'userIds': instance.userIds?.toList(),
    };
