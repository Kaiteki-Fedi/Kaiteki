import 'package:json_annotation/json_annotation.dart';

import 'account.dart';
import 'instance_configuration.dart';
import 'v1/instance.dart';

part 'instance.g.dart';

/// Represents the software instance of Mastodon running on this domain.
@JsonSerializable(fieldRename: FieldRename.snake)
class Instance {
  /// The domain name of the instance.
  final String domain;

  /// The title of the website.
  final String title;

  /// The version of Mastodon installed on the instance.
  final String version;

  /// The URL for the source code of the software running on this instance, in
  /// keeping with AGPL license requirements.
  // NULL(friendica)
  final Uri? sourceUrl;

  /// A short, plain-text description defined by the admin.
  final String description;

  /// Usage data for this instance.
  final InstanceUsage usage;

  /// An image used to represent this instance.
  final InstanceThumbnail thumbnail;

  /// Primary languages of the website and its staff.
  final Set<String> languages;

  /// Configured values and limits for this website.
  final InstanceConfiguration configuration;

  /// Information about registering for this website.
  final InstanceRegistrations registrations;

  /// Hints related to contacting a representative of the website.
  final InstanceContact contact;

  /// An itemized list of rules for this website.
  final Set<Rule> rules;

  const Instance({
    required this.domain,
    required this.title,
    required this.version,
    required this.sourceUrl,
    required this.description,
    required this.usage,
    required this.thumbnail,
    required this.languages,
    required this.configuration,
    required this.registrations,
    required this.contact,
    required this.rules,
  });

  factory Instance.fromJson(Map<String, dynamic> json) =>
      _$InstanceFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class InstanceContact {
  /// An email address that can be messaged regarding inquiries or issues.
  final String email;

  /// An account that can be contacted natively over the network regarding
  /// inquiries or issues.
  // NULL(gts)
  final Account? account;

  const InstanceContact(this.email, this.account);

  factory InstanceContact.fromJson(Map<String, dynamic> json) =>
      _$InstanceContactFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceContactToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class InstanceRegistrations {
  /// Whether registrations are enabled.
  final bool enabled;

  /// Whether registrations require moderator approval.
  final bool approvalRequired;

  /// A custom message to be shown when registrations are closed.
  final String? message;

  const InstanceRegistrations(
      this.enabled, this.approvalRequired, this.message);

  factory InstanceRegistrations.fromJson(Map<String, dynamic> json) =>
      _$InstanceRegistrationsFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceRegistrationsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class InstanceThumbnail {
  final Uri url;
  final String? blurhash;
  final Map<String, Uri>? versions;

  const InstanceThumbnail(this.url, this.blurhash, this.versions);

  factory InstanceThumbnail.fromJson(Map<String, dynamic> json) =>
      _$InstanceThumbnailFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceThumbnailToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class InstanceUsage {
  final InstanceUsageUsers users;

  const InstanceUsage(this.users);

  factory InstanceUsage.fromJson(Map<String, dynamic> json) =>
      _$InstanceUsageFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceUsageToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class InstanceUsageUsers {
  final int activeMonth;

  const InstanceUsageUsers(this.activeMonth);

  factory InstanceUsageUsers.fromJson(Map<String, dynamic> json) =>
      _$InstanceUsageUsersFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceUsageUsersToJson(this);
}
