import 'package:fediverse_objects/mastodon.dart' hide List;
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/src/typedefs.dart';

part 'search.g.dart';

@JsonSerializable()
class Search {
  final List<Status> statuses;
  final List<Account> accounts;
  final List<Tag> hashtags;

  const Search({
    this.statuses = const [],
    this.accounts = const [],
    this.hashtags = const [],
  });

  factory Search.fromJson(JsonMap json) => _$SearchFromJson(json);

  JsonMap toJson() => _$SearchToJson(this);
}
