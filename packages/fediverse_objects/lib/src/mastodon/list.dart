import 'replies_policy.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class List {
  final String id;
  final String title;
  final RepliesPolicy? repliesPolicy;

  const List({required this.id, required this.title, this.repliesPolicy});

  factory List.fromJson(Map<String, dynamic> json) => _$ListFromJson(json);

  Map<String, dynamic> toJson() => _$ListToJson(this);
}
