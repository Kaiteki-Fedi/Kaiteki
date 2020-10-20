import 'package:json_annotation/json_annotation.dart';

part 'identity.g.dart';

/// A class that both contains the domain of an instance as well as an username,
/// used for comparing what kind of data belongs to whom.
@JsonSerializable()
class Identity {
  final String username;

  final String instance;

  const Identity(this.instance, this.username);

  factory Identity.fromJson(Map<String, dynamic> json) => _$IdentityFromJson(json);
  Map<String, dynamic> toJson() => _$IdentityToJson(this);
}