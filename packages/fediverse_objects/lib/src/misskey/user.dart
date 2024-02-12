import 'package:json_annotation/json_annotation.dart';

import '../misskey_emojis_conversion.dart';
import 'avatar_decoration.dart';
import 'emoji.dart';
import 'note.dart';
import 'page.dart';
import 'user_field.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  /// The local host is represented with `null`.
  final String? host;

  @JsonKey(readValue: misskeyEmojisReadValue)
  final List<Emoji>? emojis;

  final String id;
  final String? name;
  final String username;
  final Uri? avatarUrl;
  final String? avatarBlurhash;
  final bool? isAdmin;
  final bool? isModerator;
  final bool? isBot;
  final bool? isCat;
  final UserOnlineStatus? onlineStatus;
  final Uri? url;
  final Uri? uri;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? avatarId;
  final String? backgroundId;
  final Uri? backgroundUrl;
  final Uri? bannerUrl;
  final String? bannerBlurhash;
  final String? bannerId;
  final bool? isLocked;
  final bool? isSuspended;
  final String? description;
  final String? location;
  final String? birthday;
  final List<UserField>? fields;
  final int? followersCount;
  final int? followingCount;
  final int? notesCount;
  final List<String>? pinnedNoteIds;
  final List<Note>? pinnedNotes;
  final String? pinnedPageId;
  final Page? pinnedPage;
  final bool? twoFactorEnabled;
  final bool? usePasswordLessLogin;
  final bool? securityKeys;
  final bool? autoWatch;
  final bool? injectFeaturedNote;
  final bool? alwaysMarkNsfw;
  final bool? carefulBot;
  final bool? autoAcceptFollowed;
  final bool? hasUnreadSpecifiedNotes;
  final bool? hasUnreadMentions;
  final bool? hasUnreadAnnouncement;
  final bool? hasUnreadAntenna;
  final bool? hasUnreadChannel;
  final bool? hasUnreadMessagingMessage;
  final bool? hasUnreadNotification;
  final bool? hasPendingReceivedFollowRequest;
  final List<List<String>>? mutedWords;
  final List<String>? mutedInstances;
  final bool? isFollowing;
  final bool? hasPendingFollowRequestFromYou;
  final bool? hasPendingFollowRequestToYou;
  final bool? isFollowed;
  final bool? isBlocking;
  final bool? isBlocked;
  final bool? isMuted;
  final List<AvatarDecoration>? avatarDecorations;
  final String? listenbrainz;

  const User({
    required this.id,
    required this.username,
    this.alwaysMarkNsfw,
    this.autoAcceptFollowed,
    this.autoWatch,
    this.avatarBlurhash,
    this.avatarDecorations,
    this.avatarId,
    this.avatarUrl,
    this.backgroundId,
    this.backgroundUrl,
    this.bannerBlurhash,
    this.bannerId,
    this.bannerUrl,
    this.birthday,
    this.carefulBot,
    this.createdAt,
    this.description,
    this.emojis,
    this.fields,
    this.followersCount,
    this.followingCount,
    this.hasPendingFollowRequestFromYou,
    this.hasPendingFollowRequestToYou,
    this.hasPendingReceivedFollowRequest,
    this.hasUnreadAnnouncement,
    this.hasUnreadAntenna,
    this.hasUnreadChannel,
    this.hasUnreadMentions,
    this.hasUnreadMessagingMessage,
    this.hasUnreadNotification,
    this.hasUnreadSpecifiedNotes,
    this.host,
    this.injectFeaturedNote,
    this.isAdmin,
    this.isBlocked,
    this.isBlocking,
    this.isBot,
    this.isCat,
    this.isFollowed,
    this.isFollowing,
    this.isLocked,
    this.isModerator,
    this.isMuted,
    this.isSuspended,
    this.location,
    this.mutedInstances,
    this.mutedWords,
    this.name,
    this.notesCount,
    this.onlineStatus,
    this.pinnedNoteIds,
    this.pinnedNotes,
    this.pinnedPage,
    this.pinnedPageId,
    this.securityKeys,
    this.twoFactorEnabled,
    this.updatedAt,
    this.uri,
    this.url,
    this.usePasswordLessLogin,
    this.listenbrainz,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

enum UserOnlineStatus { unknown, online, active, offline }
