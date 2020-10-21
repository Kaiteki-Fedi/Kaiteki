import 'package:json_annotation/json_annotation.dart';
part 'variable_argument.g.dart';

@JsonSerializable()
class MisskeyPageVariableArgument {
  final String id;

  final String type;

  final String value;

  const MisskeyPageVariableArgument({
    this.id,
    this.type,
    this.value,
  });

  factory MisskeyPageVariableArgument.fromJson(Map<String, dynamic> json) =>
      _$MisskeyPageVariableArgumentFromJson(json);
}
