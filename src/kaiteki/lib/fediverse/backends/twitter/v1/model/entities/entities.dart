import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/model/entities/entity.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/model/entities/hashtag.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/model/entities/media.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/model/entities/url.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/model/entities/user_mention.dart';

part 'entities.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Entities {
  /// Name of the hashtag, minus the leading ‘#’ character.
  final List<Hashtag>? hashtags;

  final List<Media>? media;

  final List<UserMention>? userMentions;

  final List<Url>? urls;

  @JsonKey(ignore: true)
  List<Entity> get aggregated {
    return <Entity>[
      if (media != null) ...media!,
      if (urls != null) ...urls!,
      if (userMentions != null) ...userMentions!,
      if (hashtags != null) ...hashtags!,
    ];
  }

  const Entities({
    required this.hashtags,
    this.media,
    this.userMentions,
    this.urls,
  });

  factory Entities.fromJson(Map<String, dynamic> json) =>
      _$EntitiesFromJson(json);

  Map<String, dynamic> toJson() => _$EntitiesToJson(this);
}
