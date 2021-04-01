// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyMuting _$MisskeyMutingFromJson(Map<String, dynamic> json) {
  return MisskeyMuting(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    muteeId: json['muteeId'] as String,
    mutee: MisskeyUser.fromJson(json['mutee'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MisskeyMutingToJson(MisskeyMuting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'muteeId': instance.muteeId,
      'mutee': instance.mutee,
    };
