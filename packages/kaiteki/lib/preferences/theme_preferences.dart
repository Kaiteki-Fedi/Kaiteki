import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/theming/themes.dart";
import "package:kaiteki/ui/pride.dart";
import "package:notified_preferences_riverpod/notified_preferences_riverpod.dart";

final theme = createEnumSettingProvider<AppTheme>(
  key: "theme",
  initialValue: AppTheme.system,
  provider: sharedPreferencesProvider,
  values: AppTheme.values,
);

final themeMode = createEnumSettingProvider<ThemeMode>(
  key: "themeMode",
  initialValue: ThemeMode.system,
  values: ThemeMode.values,
  provider: sharedPreferencesProvider,
);

final visualDensity = createSettingProvider<VisualDensity?>(
  key: "visualDensity",
  initialValue: null,
  provider: sharedPreferencesProvider,
  read: (prefs, key) {
    final value = prefs.getString(key)?.split(",").map(double.parse);
    if (value == null) return null;
    return VisualDensity(
      horizontal: value.first,
      vertical: value.last,
    );
  },
  write: (prefs, key, value) async {
    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(
        key,
        "${value.horizontal},${value.vertical}",
      );
    }
  },
);

final useNaturalBadgeColors = createSettingProvider<bool>(
  key: "useNaturalBadgeColors",
  initialValue: false,
  provider: sharedPreferencesProvider,
);

final showBadgeNumbers = createSettingProvider<bool>(
  key: "showBadgeNumbers",
  initialValue: true,
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
  write: (prefs, key, value) async {
    if (value == double.infinity) {
      await prefs.setDouble(key, -1);
    } else {
      await prefs.setDouble(key, value);
    }
  },
  read: (prefs, key) {
    final value = prefs.getDouble(key);
    return value == -1 ? double.infinity : value;
  },
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

final enablePrideFlag = createSettingProvider<bool>(
  key: "enablePrideFlag",
  initialValue: false,
  provider: sharedPreferencesProvider,
);

final prideFlag = createEnumSettingProvider<PrideFlag>(
  key: "prideFlag",
  initialValue: PrideFlag.pride,
  values: PrideFlag.values,
  provider: sharedPreferencesProvider,
);
