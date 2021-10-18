import 'package:fediverse_objects/src/pleroma/notification_settings.dart';
import 'package:fediverse_objects/src/pleroma/relationship.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  @JsonKey(name: 'accepts_chat_messages')
  final bool? acceptsChatMessages;

  @JsonKey(name: 'allow_following_move')
  final bool? allowFollowingMove;

  //@JsonKey(name: "background_image")
  //final dynamic backgroundImage;

  @JsonKey(name: 'favicon')
  final String? favicon;

  @JsonKey(name: 'chat_token')
  final String? chatToken;

  @JsonKey(name: 'confirmation_pending')
  final bool? confirmationPending;

  @JsonKey(name: 'hide_favorites')
  final bool hideFavorites;

  @JsonKey(name: 'hide_followers')
  final bool hideFollowers;

  @JsonKey(name: 'hide_followers_count')
  final bool hideFollowersCount;

  @JsonKey(name: 'hide_follows')
  final bool hideFollows;

  @JsonKey(name: 'hide_follows_count')
  final bool hideFollowsCount;

  @JsonKey(name: 'is_admin')
  final bool isAdmin;

  @JsonKey(name: 'is_moderator')
  final bool isModerator;

  @JsonKey(name: 'is_confirmed')
  final bool? isConfirmed;

  @JsonKey(name: 'notification_settings')
  final NotificationSettings? notificationSettings;

  final Relationship? relationship;

  @JsonKey(name: 'settings_store')
  final Map<String, dynamic>? settingsStore;

  @JsonKey(name: 'skip_thread_containment')
  final bool skipThreadContainment;

  //final Iterable<Tag> tags;

  @JsonKey(name: 'unread_conversation_count')
  final int? unreadConversationCount;

  const Account(
    this.acceptsChatMessages,
    this.allowFollowingMove,
    //this.backgroundImage,
    this.chatToken,
    this.confirmationPending,
    this.hideFavorites,
    this.hideFollowers,
    this.hideFollowersCount,
    this.hideFollows,
    this.hideFollowsCount,
    this.isAdmin,
    this.isModerator,
    this.isConfirmed,
    this.notificationSettings,
    this.relationship,
    //this.settingsStore,
    this.skipThreadContainment,
    //this.tags,
    this.unreadConversationCount,
    this.favicon,
    this.settingsStore,
  );

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
