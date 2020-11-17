import 'package:fediverse_objects/pleroma/emoji_pack_metadata.dart';
import 'package:json_annotation/json_annotation.dart';

part 'emoji_pack.g.dart';

@JsonSerializable(createToJson: false)
class PleromaEmojiPack {
  final Map<String, String> files;

  final PleromaEmojiPackMetadata pack;

  @JsonKey(name: "files_count")
  final int fileCount;

  const PleromaEmojiPack({
    this.files,
    this.pack,
    this.fileCount,
  });

  factory PleromaEmojiPack.fromJson(Map<String, dynamic> json) =>
      _$PleromaEmojiPackFromJson(json);
}
