import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

import 'response.dart';

part 'bookmark_response.g.dart';

typedef BookmarkResponse = Response<BookmarkResponseData>;

@JsonSerializable(createToJson: false)
class BookmarkResponseData {
  final bool bookmarked;

  const BookmarkResponseData(this.bookmarked);

  factory BookmarkResponseData.fromJson(JsonMap json) =>
      _$BookmarkResponseDataFromJson(json);
}
