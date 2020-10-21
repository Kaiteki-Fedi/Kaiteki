// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MisskeyBlocking _$MisskeyBlockingFromJson(Map<String, dynamic> json) {
  return MisskeyBlocking(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    blockeeId: json['blockeeId'] as String,
    blockee: json['blockee'] == null
        ? null
        : MisskeyUser.fromJson(json['blockee'] as Map<String, dynamic>),
  );
}
