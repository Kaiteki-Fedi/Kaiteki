import 'package:fediverse_objects/pleroma.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

part 'emoji_packs_response.g.dart';

@JsonSerializable(createToJson: false)
class PleromaEmojiPacksResponse {
  final int count;

  final Map<String, EmojiPack> packs;

  PleromaEmojiPacksResponse({
    required this.count,
    required this.packs,
  });

  factory PleromaEmojiPacksResponse.fromJson(JsonMap json) =>
      _$PleromaEmojiPacksResponseFromJson(json);
}
