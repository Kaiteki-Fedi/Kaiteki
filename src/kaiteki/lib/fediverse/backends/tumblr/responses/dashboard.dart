import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/fediverse/backends/tumblr/entities/post.dart";

part "dashboard.g.dart";

@JsonSerializable()
class DashboardResponse {
  List<Post> posts;

  DashboardResponse({required this.posts});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$DashboardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardResponseToJson(this);
}
