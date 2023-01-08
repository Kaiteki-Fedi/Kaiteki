import 'package:json_annotation/json_annotation.dart';

part 'note_translate.g.dart';

@JsonSerializable()
class NoteTranslateResponse {
  final String sourceLang;
  final String text;

  const NoteTranslateResponse(this.sourceLang, this.text);

  factory NoteTranslateResponse.fromJson(Map<String, dynamic> json) =>
      _$NoteTranslateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NoteTranslateResponseToJson(this);
}
