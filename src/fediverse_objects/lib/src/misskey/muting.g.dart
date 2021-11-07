// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Muting _$MutingFromJson(Map<String, dynamic> json) => Muting(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      muteeId: json['muteeId'] as String,
      mutee: User.fromJson(json['mutee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MutingToJson(Muting instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'muteeId': instance.muteeId,
      'mutee': instance.mutee,
    };
