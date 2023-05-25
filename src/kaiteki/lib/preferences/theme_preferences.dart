import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:notified_preferences_riverpod/notified_preferences_riverpod.dart";

final useSystemColorScheme = createSettingProvider<bool>(
  key: "useSystemColorScheme",
  initialValue: true,
  provider: sharedPreferencesProvider,
);

final useMaterial3 = createSettingProvider<bool>(
  key: "useMaterial3",
  initialValue: true,
  provider: sharedPreferencesProvider,
);

final themeMode = createEnumSettingProvider<ThemeMode>(
  key: "themeMode",
  initialValue: ThemeMode.system,
  values: ThemeMode.values,
  provider: sharedPreferencesProvider,
);

final useNaturalBadgeColors = createSettingProvider<bool>(
  key: "useNaturalBadgeColors",
  initialValue: false,
  provider: sharedPreferencesProvider,
);

final squareEmojis = createSettingProvider<bool>(
  key: "squareEmojis",
  initialValue: true,
  provider: sharedPreferencesProvider,
);

final emojiScale = createSettingProvider<double>(
  key: "emojiScale",
  initialValue: 1.5,
  provider: sharedPreferencesProvider,
);

final avatarCornerRadius = createSettingProvider<double>(
  key: "avatarCornerRadius",
  initialValue: double.infinity,
  provider: sharedPreferencesProvider,
);

final showUserBadges = createSettingProvider<bool>(
  key: "showUserBadges",
  initialValue: true,
  provider: sharedPreferencesProvider,
);

final useWidePostLayout = createSettingProvider<bool>(
  key: "useWidePostLayout",
  initialValue: false,
  provider: sharedPreferencesProvider,
);

final useFullWidthAttachments = createSettingProvider<bool>(
  key: "useFullWidthAttachments",
  initialValue: false,
  provider: sharedPreferencesProvider,
);

final postReplyPreview = createEnumSettingProvider<PostReplyPreview>(
  key: "postReplyPreview",
  initialValue: PostReplyPreview.compact,
  values: PostReplyPreview.values,
  provider: sharedPreferencesProvider,
);

enum PostReplyPreview {
  /// Show a preview of the post that is being replied to.
  normal,

  /// Only show the name of the user being replied to.
  compact,
}

final cropAttachments = createSettingProvider<bool>(
  key: "cropAttachments",
  initialValue: true,
  provider: sharedPreferencesProvider,
);

final usePostCards = createSettingProvider<bool>(
  key: "usePostCards",
  initialValue: true,
  provider: sharedPreferencesProvider,
);
