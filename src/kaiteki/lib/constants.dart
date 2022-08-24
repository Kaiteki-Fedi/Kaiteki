import 'package:flutter/rendering.dart' show BoxConstraints;

const String appName = "Kaiteki";
const String appWebsite = "https://craftplacer.moe/projects/kaiteki";
const String telegramChannel = "https://t.me/kaiteki_fedi";
const String githubRepository = "https://github.com/Kaiteki-Fedi/Kaiteki";
const String appDescription = "The comfy Fediverse client";
const String appRemoteIcon =
    "https://craftplacer.moe/projects/kaiteki/img/kaiteki.png";
const String userAgent = "Kaiteki/1.0 (+$appWebsite)";

const String exampleAvatar = "https://craftplacer.keybase.pub/cute.jpg";

const double defaultFormWidth = 448;
const double defaultFormHeight = 592;
const dialogConstraints = BoxConstraints(minWidth: 280, maxWidth: 560);
const bottomSheetConstraints = BoxConstraints(maxWidth: 560);

/// Whether to use frontend login endpoints or oauth ones.
bool get useOAuth => false;

const List<String> defaultScopes = ["read", "write", "follow", "push"];

// TODO(Craftplacer): Consider adding additional permissions based on version like Milktea, https://github.com/pantasystem/Milktea/blob/develop/features/auth/src/main/java/net/pantasystem/milktea/auth/viewmodel/Permissions.kt
const List<String> defaultMisskeyPermissions = [
  "write:user-groups",
  "read:user-groups",
  "read:page-likes",
  "write:page-likes",
  "write:pages",
  "read:pages",
  "write:votes",
  "write:reactions",
  "read:reactions",
  "write:notifications",
  "read:notifications",
  "write:notes",
  "write:mutes",
  "read:mutes",
  "read:account",
  "write:account",
  "read:blocks",
  "write:blocks",
  "read:drive",
  "write:drive",
  "read:favorites",
  "write:favorites",
  "read:following",
  "write:following",
  "read:messaging",
  "write:messaging",
];

const double defaultSplashRadius = 24.0;
