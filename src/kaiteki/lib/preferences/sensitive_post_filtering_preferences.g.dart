// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensitive_post_filtering_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensitivePostFilteringPreferences _$SensitivePostFilteringPreferencesFromJson(
        Map<String, dynamic> json) =>
    SensitivePostFilteringPreferences(
      enabled: json['enabled'] as bool? ?? false,
      filterPostsMarkedAsSensitive:
          json['filterPostsMarkedAsSensitive'] as bool? ?? true,
      filterPostsWithSubject: json['filterPostsWithSubject'] as bool? ?? false,
    );

Map<String, dynamic> _$SensitivePostFilteringPreferencesToJson(
        SensitivePostFilteringPreferences instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'filterPostsMarkedAsSensitive': instance.filterPostsMarkedAsSensitive,
      'filterPostsWithSubject': instance.filterPostsWithSubject,
    };
