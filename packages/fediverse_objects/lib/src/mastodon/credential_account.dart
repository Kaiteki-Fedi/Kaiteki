import 'package:json_annotation/json_annotation.dart';

import '../pleroma/account.dart';
import 'account.dart';
import 'custom_emoji.dart';
import 'field.dart';
import 'role.dart';
import 'source.dart';

part 'credential_account.g.dart';

/// Represents a user of Mastodon and their associated profile.
@JsonSerializable()
class CredentialAccount extends Account {
  /// The role assigned to the currently authorized user.
  final Role? role;

  const CredentialAccount({
    required super.acct,
    required super.avatar,
    required super.avatarStatic,
    required super.createdAt,
    required super.displayName,
    required super.emojis,
    required super.followersCount,
    required super.followingCount,
    required super.group,
    required super.header,
    required super.headerStatic,
    required super.id,
    required super.locked,
    required super.note,
    required super.statusesCount,
    required super.url,
    required super.username,
    super.source,
    super.bot,
    super.discoverable,
    super.fields,
    super.lastStatusAt,
    super.limited,
    super.moved,
    super.muteExpiredAt,
    super.noindex,
    super.pleroma,
    super.suspended,
    this.role,
  });

  factory CredentialAccount.fromJson(Map<String, dynamic> json) =>
      _$CredentialAccountFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CredentialAccountToJson(this);
}
