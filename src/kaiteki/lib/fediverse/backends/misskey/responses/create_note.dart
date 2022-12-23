import 'package:fediverse_objects/misskey.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_note.g.dart';

@JsonSerializable()
class CreateNoteResponse {
  final Note createdNote;

  const CreateNoteResponse(this.createdNote);

  factory CreateNoteResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateNoteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateNoteResponseToJson(this);
}
