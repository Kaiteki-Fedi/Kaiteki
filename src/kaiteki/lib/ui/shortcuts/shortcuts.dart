import 'package:flutter/widgets.dart'
    show Intent, ShortcutActivator, WidgetsApp;
import 'package:kaiteki/ui/shortcuts/activators.dart';
import 'package:kaiteki/ui/shortcuts/intents.dart';

final shortcuts = <ShortcutActivator, Intent>{
  ...WidgetsApp.defaultShortcuts,
  refresh: const RefreshIntent(),
  refresh2: const RefreshIntent(),
  refresh3: const RefreshIntent(),
  shortcutsHelp: const ShortcutsHelpIntent(),
  gotoHome: const GoToAppLocationIntent(AppLocation.home),
  gotoSettings: const GoToAppLocationIntent(AppLocation.settings),
  gotoBookmarks: const GoToAppLocationIntent(AppLocation.bookmarks),
  gotoNotifications: const GoToAppLocationIntent(AppLocation.notifications),
  newPost: const NewPostIntent(),
};
