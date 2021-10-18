// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContextResponse _$ContextResponseFromJson(Map<String, dynamic> json) {
  return ContextResponse(
    (json['ancestors'] as List<dynamic>)
        .map((e) => Status.fromJson(e as Map<String, dynamic>)),
    (json['descendants'] as List<dynamic>)
        .map((e) => Status.fromJson(e as Map<String, dynamic>)),
  );
}
