import 'package:fediverse_objects/misskey.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';

part 'create_note.g.dart';

@JsonSerializable()
class CreateNoteResponse {
  final Note createdNote;

  const CreateNoteResponse(this.createdNote);

  factory CreateNoteResponse.fromJson(JsonMap json) =>
      _$CreateNoteResponseFromJson(json);

  JsonMap toJson() => _$CreateNoteResponseToJson(this);
}
