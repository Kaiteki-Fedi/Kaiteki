import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/api/model/pleroma/notification_settings.dart';
import 'package:kaiteki/api/model/pleroma/relationship.dart';
part 'account.g.dart';

@JsonSerializable(createToJson: false)
class PleromaAccount {
	@JsonKey(name: "accepts_chat_messages")
	final bool acceptsChatMessages;

	@JsonKey(name: "allow_following_move")
	final bool allowFollowingMove;

	//@JsonKey(name: "background_image")
	//final dynamic backgroundImage;

	@JsonKey(name: "chat_token")
	final String chatToken;

	@JsonKey(name: "confirmation_pending")
	final bool confirmationPending;

	@JsonKey(name: "hide_favorites")
	final bool hideFavorites;

	@JsonKey(name: "hide_followers")
	final bool hideFollowers;

	@JsonKey(name: "hide_followers_count")
	final bool hideFollowersCount;

	@JsonKey(name: "hide_follows")
	final bool hideFollows;

	@JsonKey(name: "hide_follows_count")
	final bool hideFollowsCount;

	@JsonKey(name: "is_admin")
	final bool isAdmin;

	@JsonKey(name: "is_moderator")
	final bool isModerator;

	@JsonKey(name: "notification_settings")
	final PleromaNotificationSettings notificationSettings;

	final PleromaRelationship relationship;

	//@JsonKey(name: "settings_store")
	//final Map<String, dynamic> settingsStore;

	@JsonKey(name: "skip_thread_containment")
	final bool skipThreadContainment;

	//final Iterable<Tag> tags;

	@JsonKey(name: "unread_conversation_count")
	final int unreadConversationCount;

	const PleromaAccount(
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
		this.notificationSettings,
		this.relationship,
		//this.settingsStore,
		this.skipThreadContainment,
		//this.tags,
		this.unreadConversationCount,
	);

	factory PleromaAccount.fromJson(Map<String, dynamic> json) => _$PleromaAccountFromJson(json);
}