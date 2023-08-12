import 'package:fediverse_objects/misskey.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

part 'emojis.g.dart';

@JsonSerializable()
class EmojisResponse {
  final List<Emoji> emojis;

  const EmojisResponse(this.emojis);

  factory EmojisResponse.fromJson(JsonMap json) =>
      _$EmojisResponseFromJson(json);

  JsonMap toJson() => _$EmojisResponseToJson(this);
}
