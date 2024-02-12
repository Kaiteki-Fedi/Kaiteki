// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antenna.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Antenna _$AntennaFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Antenna',
      json,
      ($checkedConvert) {
        final val = Antenna(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          name: $checkedConvert('name', (v) => v as String),
          keywords: $checkedConvert(
              'keywords',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      (e as List<dynamic>).map((e) => e as String).toList())
                  .toList()),
          excludeKeywords: $checkedConvert(
              'excludeKeywords',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      (e as List<dynamic>).map((e) => e as String).toList())
                  .toList()),
          src: $checkedConvert(
              'src', (v) => $enumDecode(_$AntennaSrcEnumMap, v)),
          userListId: $checkedConvert('userListId', (v) => v as String?),
          userGroupId: $checkedConvert('userGroupId', (v) => v as String?),
          users: $checkedConvert('users',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          caseSensitive: $checkedConvert('caseSensitive', (v) => v as bool),
          notify: $checkedConvert('notify', (v) => v as bool),
          withReplies: $checkedConvert('withReplies', (v) => v as bool),
          withFile: $checkedConvert('withFile', (v) => v as bool),
          hasUnreadNote: $checkedConvert('hasUnreadNote', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$AntennaToJson(Antenna instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'keywords': instance.keywords,
      'excludeKeywords': instance.excludeKeywords,
      'src': _$AntennaSrcEnumMap[instance.src]!,
      'userListId': instance.userListId,
      'userGroupId': instance.userGroupId,
      'users': instance.users,
      'caseSensitive': instance.caseSensitive,
      'notify': instance.notify,
      'withReplies': instance.withReplies,
      'withFile': instance.withFile,
      'hasUnreadNote': instance.hasUnreadNote,
    };

const _$AntennaSrcEnumMap = {
  AntennaSrc.home: 'home',
  AntennaSrc.all: 'all',
  AntennaSrc.users: 'users',
  AntennaSrc.list: 'list',
  AntennaSrc.group: 'group',
};
