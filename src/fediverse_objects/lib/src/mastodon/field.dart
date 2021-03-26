import 'package:json_annotation/json_annotation.dart';
part 'field.g.dart';

@JsonSerializable()
class MastodonField {
  final String name;

  final String value;

  const MastodonField(this.name, this.value);

  factory MastodonField.fromJson(Map<String /*!*/, dynamic> /*!*/ json) =>
      _$MastodonFieldFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonFieldToJson(this);
}
