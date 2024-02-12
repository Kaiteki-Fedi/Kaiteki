// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaSource _$PleromaSourceFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PleromaSource',
      json,
      ($checkedConvert) {
        final val = PleromaSource(
          $checkedConvert('show_role', (v) => v as bool?),
          $checkedConvert('no_rich_text', (v) => v as bool?),
          $checkedConvert('discoverable', (v) => v as bool),
          $checkedConvert('actor_type', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'showRole': 'show_role',
        'noRichText': 'no_rich_text',
        'actorType': 'actor_type'
      },
    );

Map<String, dynamic> _$PleromaSourceToJson(PleromaSource instance) =>
    <String, dynamic>{
      'show_role': instance.showRole,
      'no_rich_text': instance.noRichText,
      'discoverable': instance.discoverable,
      'actor_type': instance.actorType,
    };
