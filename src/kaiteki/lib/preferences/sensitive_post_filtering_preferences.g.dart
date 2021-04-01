// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensitive_post_filtering_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensitivePostFilteringPreferences _$SensitivePostFilteringPreferencesFromJson(
    Map<String, dynamic> json) {
  return SensitivePostFilteringPreferences(
    enabled: json['enabled'] as bool,
    filterPostsMarkedAsSensitive: json['filterPostsMarkedAsSensitive'] as bool,
    filterPostsWithSubject: json['filterPostsWithSubject'] as bool,
  );
}

Map<String, dynamic> _$SensitivePostFilteringPreferencesToJson(
        SensitivePostFilteringPreferences instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'filterPostsMarkedAsSensitive': instance.filterPostsMarkedAsSensitive,
      'filterPostsWithSubject': instance.filterPostsWithSubject,
    };
