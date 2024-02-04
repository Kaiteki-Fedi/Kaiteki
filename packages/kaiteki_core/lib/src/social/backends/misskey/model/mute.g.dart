// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mute _$MuteFromJson(Map<String, dynamic> json) => Mute(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      muteeId: json['muteeId'] as String,
      mutee: User.fromJson(json['mutee'] as Map<String, dynamic>),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$MuteToJson(Mute instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'muteeId': instance.muteeId,
      'mutee': instance.mutee,
    };
