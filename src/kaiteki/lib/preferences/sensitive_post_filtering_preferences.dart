import 'package:json_annotation/json_annotation.dart';
part 'sensitive_post_filtering_preferences.g.dart';

@JsonSerializable(includeIfNull: false, createFactory: true, createToJson: true)
class SensitivePostFilteringPreferences {
  bool enabled = false;
  bool filterPostsMarkedAsSensitive = true;
  bool filterPostsWithSubject = false;

  SensitivePostFilteringPreferences({
    this.enabled = false,
    this.filterPostsMarkedAsSensitive = true,
    this.filterPostsWithSubject = false,
  });

  factory SensitivePostFilteringPreferences.fromJson(
          Map<String, dynamic> json) =>
      _$SensitivePostFilteringPreferencesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SensitivePostFilteringPreferencesToJson(this);
}
