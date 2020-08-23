class PleromaAccount {
	String apId;
	String backgroundImage;
	bool confirmationPending;
	bool hideFavorites;
	bool hideFollowers;
	bool hideFollowersCount;
	bool hideFollows;
	bool hideFollowsCount;
	bool isAdmin;
	bool isModerator;
//	dynamic relationship;
	bool skipThreadContainment;
//	List<dynamic> tags;

	PleromaAccount.fromJson(Map<String, dynamic> json) {
		apId = json["ap_id"];
		backgroundImage = json["background_image"];
		confirmationPending = json["confirmation_pending"];
		hideFavorites = json["hide_favorites"];
		hideFollowers = json["hide_followers"];
		hideFollowersCount = json["hide_followers_count"];
		hideFollows = json["hide_follows"];
		hideFollowsCount = json["hide_follows_count"];
		isAdmin = json["is_admin"];
		isModerator = json["is_moderator"];
//		relationship = json["relationship"];
		skipThreadContainment = json["skip_thread_containment"];
//		tags = json["tags"];
	}
}
