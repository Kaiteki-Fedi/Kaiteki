import 'package:json_annotation/json_annotation.dart';

part 'avatar_decoration.g.dart';

@JsonSerializable()
class AvatarDecoration {
  final String id;
  final Uri url;
  final double? angle;
  final bool? flipH;

  const AvatarDecoration({
    required this.id,
    required this.url,
    this.angle,
    this.flipH,
  });

  factory AvatarDecoration.fromJson(Map<String, dynamic> json) =>
      _$AvatarDecorationFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarDecorationToJson(this);
}
