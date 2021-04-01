import 'package:json_annotation/json_annotation.dart';
part 'tag.g.dart';

@JsonSerializable()
class MastodonTag {
  final String name;

  final String url;

  const MastodonTag({
    required this.name,
    required this.url,
  });

  factory MastodonTag.fromJson(Map<String, dynamic> json) =>
      _$MastodonTagFromJson(json);

  Map<String, dynamic> toJson() => _$MastodonTagToJson(this);
}
