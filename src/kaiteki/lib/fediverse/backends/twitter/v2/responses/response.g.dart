// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Response<T> _$ResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Response<T>(
      data: fromJsonT(json['data']),
      includes: json['includes'] == null
          ? null
          : ResponseIncludes.fromJson(json['includes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResponseToJson<T>(
  Response<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': toJsonT(instance.data),
      'includes': instance.includes,
    };

ResponseIncludes _$ResponseIncludesFromJson(Map<String, dynamic> json) =>
    ResponseIncludes(
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toSet(),
      tweets: (json['tweets'] as List<dynamic>?)
          ?.map((e) => Tweet.fromJson(e as Map<String, dynamic>))
          .toSet(),
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toSet(),
    );

Map<String, dynamic> _$ResponseIncludesToJson(ResponseIncludes instance) =>
    <String, dynamic>{
      'users': instance.users?.toList(),
      'tweets': instance.tweets?.toList(),
      'media': instance.media?.toList(),
    };

ResponseError _$ResponseErrorFromJson(Map<String, dynamic> json) =>
    ResponseError(
      json['message'] as String,
      parameters: json['parameters'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$ResponseErrorToJson(ResponseError instance) =>
    <String, dynamic>{
      'message': instance.message,
      'parameters': instance.parameters,
    };
