import 'package:json_annotation/json_annotation.dart';

part 'source.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PleromaSource {
  final bool? showRole;
  final bool? noRichText;
  final bool discoverable;
  final String actorType;

  const PleromaSource(
      this.showRole, this.noRichText, this.discoverable, this.actorType);

  factory PleromaSource.fromJson(Map<String, dynamic> json) =>
      _$PleromaSourceFromJson(json);

  Map<String, dynamic> toJson() => _$PleromaSourceToJson(this);
}
