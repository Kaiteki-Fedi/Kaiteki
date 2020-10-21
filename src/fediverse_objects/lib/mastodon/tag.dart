import 'package:json_annotation/json_annotation.dart';
part 'tag.g.dart';

@JsonSerializable(createToJson: false)
class MastodonTag {
  final String name;

  final String url;

  const MastodonTag({
    this.name,
    this.url,
  });

  factory MastodonTag.fromJson(Map<String, dynamic> json) => _$MastodonTagFromJson(json);
}