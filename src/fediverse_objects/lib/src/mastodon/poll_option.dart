import 'package:json_annotation/json_annotation.dart';

part 'poll_option.g.dart';

@JsonSerializable()
class PollOption {
  final String title;

  @JsonKey(name: 'votes_count')
  final int? votesCount;

  PollOption({
    required this.title,
    this.votesCount,
  });

  factory PollOption.fromJson(Map<String, dynamic> json) =>
      _$PollOptionFromJson(json);

  Map<String, dynamic> toJson() => _$PollOptionToJson(this);
}
