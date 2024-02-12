import 'notification_settings.dart';
import 'relationship.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PleromaAccount {
  final bool? acceptsChatMessages;

  /// whether the user allows automatically follow moved following accounts
  final bool? allowFollowingMove;

  final List<String> alsoKnownAs;

  final Uri? backgroundImage;

  final DateTime? birthday;

  /// Favicon image of the user's instance
  final Uri? favicon;

  final String? chatToken;

  final bool? confirmationPending;

  final bool hideFavorites;

  /// whether the user has follower hiding enabled
  final bool hideFollowers;

  /// whether the user has follower stat hiding enabled
  final bool hideFollowersCount;

  /// whether the user has follow hiding enabled
  final bool hideFollows;

  /// whether the user has follow stat hiding enabled
  final bool hideFollowsCount;

  /// whether the user is an admin of the local instance
  final bool? isAdmin;

  /// whether the user is a moderator of the local instance
  final bool? isModerator;

  /// whether the user account is waiting on email confirmation to be activated
  final bool? isConfirmed;

  final NotificationSettings? notificationSettings;

  /// Relationship between current account and requested account
  final Relationship? relationship;

  /// A generic map of settings for frontends. Opaque to the backend. Only
  /// returned in `verify_credentials` and `update_credentials`
  final Map<String, dynamic>? settingsStore;

  final bool skipThreadContainment;

  /// List of tags being used for things like extra roles or moderation(ie.
  /// marking all media as nsfw all).
  final List<String> tags;

  /// The count of unread conversations. Only returned to the account owner.
  final int? unreadConversationCount;

  final int? unreadNotificationsCount;

  final bool? deactivated;

  final String? apId;

  const PleromaAccount({
    this.acceptsChatMessages,
    this.allowFollowingMove,
    this.chatToken,
    this.confirmationPending,
    required this.hideFavorites,
    required this.hideFollowers,
    required this.hideFollowersCount,
    required this.hideFollows,
    required this.hideFollowsCount,
    this.isAdmin,
    this.isModerator,
    this.isConfirmed,
    this.notificationSettings,
    this.relationship,
    required this.skipThreadContainment,
    this.unreadConversationCount,
    this.favicon,
    this.settingsStore,
    required this.alsoKnownAs,
    this.backgroundImage,
    this.birthday,
    required this.tags,
    this.unreadNotificationsCount,
    this.deactivated,
    this.apId,
  });

  factory PleromaAccount.fromJson(Map<String, dynamic> json) =>
      _$PleromaAccountFromJson(json);

  Map<String, dynamic> toJson() => _$PleromaAccountToJson(this);
}
