// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGroup _$UserGroupFromJson(Map<String, dynamic> json) {
  return UserGroup(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    name: json['name'] as String,
    ownerId: json['ownerId'] as String,
    userIds: (json['userIds'] as List<dynamic>).map((e) => e as String),
  );
}

Map<String, dynamic> _$UserGroupToJson(UserGroup instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'ownerId': instance.ownerId,
      'userIds': instance.userIds.toList(),
    };
