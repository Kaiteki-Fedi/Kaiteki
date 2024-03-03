// ignore_for_file: l10n

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/auth/oauth.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";
import "package:kaiteki_ui/kaiteki_ui.dart";
import "package:url_launcher/url_launcher.dart";

class DebugScreen extends ConsumerStatefulWidget {
  const DebugScreen({super.key});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final developerMode = ref.watch(preferences.developerMode).value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsDebugMaintenance)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsContainer(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MainSwitchListTile(
                      title: const Text("Enable developer mode"),
                      onChanged: (value) =>
                          ref.read(preferences.developerMode).value = value,
                      value: developerMode,
                      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                  SettingsSection(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.palette_rounded),
                        title: const Text("Show theme"),
                        onTap: () => context.push("/settings/debug/theme"),
                        enabled: developerMode,
                      ),
                      ListTile(
                        leading: const Icon(Icons.key_rounded),
                        title: const Text("Run OAuth Server"),
                        onTap: onRunOAuthServer,
                        enabled: developerMode,
                      ),
                      ListTile(
                        leading: const Icon(Icons.waving_hand_rounded),
                        title: const Text("Open onboarding"),
                        onTap: () {
                          ref.read(preferences.hasFinishedOnboarding).value =
                              false;
                          context.go("/onboarding");
                        },
                        enabled: developerMode,
                      ),
                      ListTile(
                        leading: const Icon(Icons.feedback_rounded),
                        title: const Text("Open exception dialog"),
                        onTap: onOpenExceptionDialog,
                        enabled: developerMode,
                      ),
                      ListTile(
                        leading: const SizedBox(),
                        title: const Text("Begin stream"),
                        onTap: _onBeginStreaming,
                        enabled: developerMode,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onRunOAuthServer() async {
    final successPage = await generateLandingPage(
      Theme.of(context).colorScheme,
    );
    await runServer((u, _) => launchUrl(u), successPage);
  }

  Future<void> onOpenExceptionDialog() async {
    try {
      throw Exception("Test exception");
    } catch (e, s) {
      await context.showExceptionDialog((e, s));
    }
  }

  Future<void> _onBeginStreaming() async {
    final streaming = ref.read(adapterProvider) as StreamSupport;

    await for (final event
        in streaming.listenToTimeline(TimelineType.following)) {
      print(event);
    }
  }
}
