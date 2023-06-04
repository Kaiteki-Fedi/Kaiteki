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

ResponseError _$ResponseErrorFromJson(Map<String, dynamic> json) =>
    ResponseError(
      json['message'] as String,
      parameters: json['parameters'] as Map<String, dynamic>? ?? const {},
    );
