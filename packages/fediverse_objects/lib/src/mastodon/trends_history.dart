import 'package:json_annotation/json_annotation.dart';

part 'trends_history.g.dart';

@JsonSerializable()
class TrendsHistory {
  @JsonKey(fromJson: _dateTimeFromTimestamp)
  final DateTime day;

  @JsonKey(fromJson: _intFromString)
  final int uses;

  @JsonKey(fromJson: _intFromString)
  final int accounts;

  const TrendsHistory({
    required this.day,
    required this.uses,
    required this.accounts,
  });

  factory TrendsHistory.fromJson(Map<String, dynamic> json) =>
      _$TrendsHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$TrendsHistoryToJson(this);
}

DateTime _dateTimeFromTimestamp(dynamic value) {
  if (value is String) {
    return DateTime.parse(value);
  } else if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  } else {
    throw ArgumentError.value(value, 'value', 'Must be String or int');
  }
}

int _intFromString(dynamic value) {
  if (value is int) {
    return value;
  } else if (value is String) {
    return int.parse(value);
  } else {
    throw ArgumentError.value(value, 'value', 'Must be int or String');
  }
}
