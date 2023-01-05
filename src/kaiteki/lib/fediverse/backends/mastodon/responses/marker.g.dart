// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Marker _$MarkerFromJson(Map<String, dynamic> json) => Marker(
      lastReadId: json['last_read_id'] as String,
      version: json['version'] as int,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

MarkerResponse _$MarkerResponseFromJson(Map<String, dynamic> json) =>
    MarkerResponse(
      notifications: json['notifications'] == null
          ? null
          : Marker.fromJson(json['notifications'] as Map<String, dynamic>),
      home: json['home'] == null
          ? null
          : Marker.fromJson(json['home'] as Map<String, dynamic>),
    );
