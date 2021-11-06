// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reversi_matching.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReversiMatching _$ReversiMatchingFromJson(Map<String, dynamic> json) =>
    ReversiMatching(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      parentId: json['parentId'] as String,
      parent: json['parent'] == null
          ? null
          : User.fromJson(json['parent'] as Map<String, dynamic>),
      childId: json['childId'] as String,
      child: User.fromJson(json['child'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReversiMatchingToJson(ReversiMatching instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'parentId': instance.parentId,
      'parent': instance.parent,
      'childId': instance.childId,
      'child': instance.child,
    };
