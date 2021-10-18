import 'package:fediverse_objects/src/pleroma/emoji_pack_metadata.dart';
import 'package:json_annotation/json_annotation.dart';

part 'emoji_pack.g.dart';

@JsonSerializable(createToJson: false)
class EmojiPack {
  final Map<String, String> files;

  final EmojiPackMetadata pack;

  @JsonKey(name: 'files_count')
  final int? fileCount;

  const EmojiPack({
    required this.files,
    required this.pack,
    this.fileCount,
  });

  factory EmojiPack.fromJson(Map<String, dynamic> json) =>
      _$EmojiPackFromJson(json);
}
