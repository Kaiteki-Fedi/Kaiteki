// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyMuting _$MisskeyMutingFromJson(Map<String, dynamic> json) {
  return MisskeyMuting(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    muteeId: json['muteeId'] as String,
    mutee: json['mutee'] == null
        ? null
        : MisskeyUser.fromJson(json['mutee'] as Map<String, dynamic>),
  );
}
