// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antenna.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyAntenna _$MisskeyAntennaFromJson(Map<String, dynamic> json) {
  return MisskeyAntenna(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    name: json['name'] as String,
    keywords: (json['keywords'] as List)
        ?.map((e) => (e as List)?.map((e) => e as String)),
    excludeKeywords: (json['excludeKeywords'] as List)
        ?.map((e) => (e as List)?.map((e) => e as String)),
    src: json['src'] as String,
    userListId: json['userListId'] as String,
    userGroupId: json['userGroupId'] as String,
    users: (json['users'] as List)?.map((e) => e as String),
    caseSensitive: json['caseSensitive'] as bool,
    notify: json['notify'] as bool,
    withReplies: json['withReplies'] as bool,
    withFile: json['withFile'] as bool,
    hasUnreadNote: json['hasUnreadNote'] as bool,
  );
}

Map<String, dynamic> _$MisskeyAntennaToJson(MisskeyAntenna instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'name': instance.name,
      'keywords': instance.keywords?.map((e) => e?.toList())?.toList(),
      'excludeKeywords':
          instance.excludeKeywords?.map((e) => e?.toList())?.toList(),
      'src': instance.src,
      'userListId': instance.userListId,
      'userGroupId': instance.userGroupId,
      'users': instance.users?.toList(),
      'caseSensitive': instance.caseSensitive,
      'notify': instance.notify,
      'withReplies': instance.withReplies,
      'withFile': instance.withFile,
      'hasUnreadNote': instance.hasUnreadNote,
    };
