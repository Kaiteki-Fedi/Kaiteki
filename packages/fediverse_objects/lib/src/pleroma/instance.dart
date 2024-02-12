import 'package:json_annotation/json_annotation.dart';

part 'instance.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PleromaInstance {
  final InstanceMetadata metadata;

  const PleromaInstance(this.metadata);

  factory PleromaInstance.fromJson(Map<String, dynamic> json) =>
      _$PleromaInstanceFromJson(json);

  Map<String, dynamic> toJson() => _$PleromaInstanceToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class InstanceMetadata {
  final bool accountActivationRequired;
  final Set<String> features;
  final Set<String> postFormats;

  const InstanceMetadata({
    required this.accountActivationRequired,
    required this.features,
    required this.postFormats,
  });

  factory InstanceMetadata.fromJson(Map<String, dynamic> json) =>
      _$InstanceMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceMetadataToJson(this);
}
