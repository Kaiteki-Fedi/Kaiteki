// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PleromaCard _$PleromaCardFromJson(Map<String, dynamic> json) => $checkedCreate(
      'PleromaCard',
      json,
      ($checkedConvert) {
        final val = PleromaCard(
          $checkedConvert('opengraph', (v) => v as Map<String, dynamic>),
        );
        return val;
      },
    );

Map<String, dynamic> _$PleromaCardToJson(PleromaCard instance) =>
    <String, dynamic>{
      'opengraph': instance.opengraph,
    };
