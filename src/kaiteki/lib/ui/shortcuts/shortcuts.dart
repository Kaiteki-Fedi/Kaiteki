import "package:flutter/material.dart"
    show
        DoNothingAndStopPropagationTextIntent,
        Intent,
        ShortcutActivator,
        SingleActivator,
        WidgetsApp;
import "package:flutter/services.dart";
import "package:kaiteki/ui/shortcuts/activators.dart";
import "package:kaiteki/ui/shortcuts/intents.dart";

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
  openMenu: const OpenMenuIntent(),
  openLauncher: const OpenLauncherIntent(),
  const SingleActivator(LogicalKeyboardKey.f1, shift: true):
      const ToggleDebugFlagIntent(DebugFlag.debugShowMaterialGrid),
  const SingleActivator(LogicalKeyboardKey.f2, shift: true):
      const ToggleDebugFlagIntent(DebugFlag.showPerformanceOverlay),
  const SingleActivator(LogicalKeyboardKey.f3, shift: true):
      const ToggleDebugFlagIntent(DebugFlag.checkerboardRasterCacheImages),
  const SingleActivator(LogicalKeyboardKey.f4, shift: true):
      const ToggleDebugFlagIntent(DebugFlag.checkerboardOffscreenLayers),
  const SingleActivator(LogicalKeyboardKey.f5, shift: true):
      const ToggleDebugFlagIntent(DebugFlag.showSemanticsDebugger),
  const SingleActivator(LogicalKeyboardKey.f6, shift: true):
      const ToggleDebugFlagIntent(DebugFlag.debugShowCheckedModeBanner),
};

final propagatingTextFieldShortcuts = {
  for (final activator in propagatingTextFieldActivators)
    activator: const DoNothingAndStopPropagationTextIntent(),
};
