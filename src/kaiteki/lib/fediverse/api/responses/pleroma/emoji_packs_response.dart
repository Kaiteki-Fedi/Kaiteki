import 'package:fediverse_objects/pleroma/emoji_pack.dart';
import 'package:json_annotation/json_annotation.dart';

part 'emoji_packs_response.g.dart';

@JsonSerializable(createToJson: false)
class PleromaEmojiPacksResponse {
  final int count;

  final Map<String, PleromaEmojiPack> packs;

  PleromaEmojiPacksResponse({this.count, this.packs});

  factory PleromaEmojiPacksResponse.fromJson(Map<String, dynamic> json) =>
      _$PleromaEmojiPacksResponseFromJson(json);
}
