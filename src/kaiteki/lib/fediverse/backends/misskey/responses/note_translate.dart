import "package:json_annotation/json_annotation.dart";
import "package:kaiteki/utils/utils.dart";

part "note_translate.g.dart";

@JsonSerializable()
class NoteTranslateResponse {
  final String sourceLang;
  final String text;

  const NoteTranslateResponse(this.sourceLang, this.text);

  factory NoteTranslateResponse.fromJson(JsonMap json) =>
      _$NoteTranslateResponseFromJson(json);

  JsonMap toJson() => _$NoteTranslateResponseToJson(this);
}
