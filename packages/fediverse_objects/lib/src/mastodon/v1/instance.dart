import 'package:json_annotation/json_annotation.dart';

import '../../pleroma/instance.dart';
import '../account.dart';
import '../instance_configuration.dart';
import '../instance_urls.dart';
import 'instance_statistics.dart';

part 'instance.g.dart';

/// Represents the software instance of Mastodon running on this domain.
@JsonSerializable(fieldRename: FieldRename.snake)
class Instance {
  final int? avatarUploadLimit;

  final String? backgroundImage;

  final int? backgroundUploadLimit;

  final int? bannerUploadLimit;

  /// Admin-defined description of the Mastodon site.
  final String description;

  /// A shorter description defined by the admin.
  final String? shortDescription;

  /// An email that may be contacted for any inquiries.
  final String email;

  /// Primary langauges of the website and its staff.
  final List<String>? languages;

  final int? maxTootChars;

  final dynamic pollLimits;

  /// Whether registrations are enabled.
  final bool registrations;

  final String? thumbnail;

  /// The title of the website.
  final String title;

  final int? uploadLimit;

  /// The domain name of the instance.
  final String uri;

  /// URLs of interest for clients apps.
  final InstanceUrls urls;

  /// The version of Mastodon installed on the instance.
  final String version;

  /// Statistics about how much information the instance contains.
  final InstanceStatistics stats;

  /// A user that can be contacted, as an alternative to [email].
  final Account? contact;

  /// Whether invites are enabled.
  final bool? invitesEnabled;

  /// Whether registrations require moderator approval.
  // NULL(pleroma)
  final bool? approvalRequired;

  final PleromaInstance? pleroma;

  final List<Rule>? rules;

  final InstanceConfiguration? configuration;

  const Instance({
    required this.uri,
    required this.title,
    required this.description,
    required this.email,
    required this.version,
    required this.languages,
    required this.registrations,
    required this.approvalRequired,
    required this.urls,
    required this.stats,
    this.shortDescription,
    this.invitesEnabled,
    this.thumbnail,
    this.contact,
    this.avatarUploadLimit,
    this.backgroundImage,
    this.backgroundUploadLimit,
    this.bannerUploadLimit,
    this.maxTootChars,
    this.pollLimits,
    this.uploadLimit,
    this.pleroma,
    this.rules,
    this.configuration,
  });

  factory Instance.fromJson(Map<String, dynamic> json) =>
      _$InstanceFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Rule {
  final String id;
  final String text;

  const Rule(this.id, this.text);

  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);

  Map<String, dynamic> toJson() => _$RuleToJson(this);
}
