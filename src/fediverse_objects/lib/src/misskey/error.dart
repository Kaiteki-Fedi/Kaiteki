import 'package:json_annotation/json_annotation.dart';
part 'error.g.dart';

@JsonSerializable()
class MisskeyError {
  /// An error object.
  @JsonKey(name: 'error')
  final Map<String, dynamic> error;
  
  const MisskeyError({
    required this.error,
  });

  factory MisskeyError.fromJson(Map<String, dynamic> json) => _$MisskeyErrorFromJson(json);
  Map<String, dynamic> toJson() => _$MisskeyErrorToJson(this);
}
