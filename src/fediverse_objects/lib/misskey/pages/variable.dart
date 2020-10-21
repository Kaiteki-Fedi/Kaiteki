import 'package:json_annotation/json_annotation.dart';
import 'package:fediverse_objects/misskey/pages/variable_argument.dart';
part 'variable.g.dart';

@JsonSerializable()
class MisskeyPageVariable {
  final String id;

  final Iterable<MisskeyPageVariableArgument> args;

  final String name;

  final String type;

  final dynamic value;

  const MisskeyPageVariable({
    this.id,
    this.args,
    this.name,
    this.type,
    this.value,
  });

  factory MisskeyPageVariable.fromJson(Map<String, dynamic> json) =>
      _$MisskeyPageVariableFromJson(json);
}
