// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trends_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendsHistory _$TrendsHistoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'TrendsHistory',
      json,
      ($checkedConvert) {
        final val = TrendsHistory(
          day: $checkedConvert('day', (v) => _dateTimeFromTimestamp(v)),
          uses: $checkedConvert('uses', (v) => _intFromString(v)),
          accounts: $checkedConvert('accounts', (v) => _intFromString(v)),
        );
        return val;
      },
    );

Map<String, dynamic> _$TrendsHistoryToJson(TrendsHistory instance) =>
    <String, dynamic>{
      'day': instance.day.toIso8601String(),
      'uses': instance.uses,
      'accounts': instance.accounts,
    };
