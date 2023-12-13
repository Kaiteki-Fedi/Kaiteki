import 'package:json_annotation/json_annotation.dart';

import 'emoji.dart';

part 'group.g.dart';

@JsonSerializable(createToJson: false)
class EmojiGroup {
  final String group;
  final List<Emoji> emoji;

  const EmojiGroup(this.group, this.emoji);

  factory EmojiGroup.fromJson(Map<String, dynamic> json) =>
      _$EmojiGroupFromJson(json);
}
