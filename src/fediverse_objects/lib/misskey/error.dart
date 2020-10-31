import 'package:json_annotation/json_annotation.dart';
part 'error.g.dart';

@JsonSerializable(createToJson: false)
class MisskeyError {
  final String message;

  final String code;

  // TODO: Change MisskeyError.id's type to GUID/UUID
  final String id;

  MisskeyError(this.message, this.code, this.id);

  factory MisskeyError.fromJson(Map<String, dynamic> json) =>
      _$MisskeyErrorFromJson(json);
}
