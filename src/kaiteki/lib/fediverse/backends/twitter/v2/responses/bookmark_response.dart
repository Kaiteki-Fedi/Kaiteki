import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/fediverse/backends/twitter/v2/responses/response.dart";
import "package:kaiteki/utils/utils.dart";

part "bookmark_response.g.dart";

typedef BookmarkResponse = Response<BookmarkResponseData>;

@JsonSerializable()
class BookmarkResponseData {
  final bool bookmarked;

  const BookmarkResponseData(this.bookmarked);

  factory BookmarkResponseData.fromJson(JsonMap json) =>
      _$BookmarkResponseDataFromJson(json);
}
