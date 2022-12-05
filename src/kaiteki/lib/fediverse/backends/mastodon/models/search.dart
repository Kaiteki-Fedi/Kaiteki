import 'package:fediverse_objects/mastodon.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search.g.dart';

@JsonSerializable()
class Search {
  final List<Status> statuses;
  final List<Account> accounts;
  // TODO(Craftplacer): Implement Mastodon hashtag model
  // final List<Hashtag> hashtags;

  const Search({
    this.statuses = const [],
    this.accounts = const [],
  });

  factory Search.fromJson(Map<String, dynamic> json) => _$SearchFromJson(json);

  Map<String, dynamic> toJson() => _$SearchToJson(this);
}
