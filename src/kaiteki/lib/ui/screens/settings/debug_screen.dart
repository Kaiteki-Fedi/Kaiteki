import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/auth/login_functions.dart';
import 'package:kaiteki/di.dart';
import 'package:mdi/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({Key? key}) : super(key: key);

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsDebugMaintenance)),
      body: Column(
        children: [
          const Material(
            elevation: 6,
            color: Colors.red,
            child: ListTile(
              leading: Icon(Mdi.alert),
              title: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Please proceed here with caution as some settings might have unintended behavior or delete your user settings.',
                ),
              ),
              dense: true,
            ),
          ),
          ListTile(
            leading: const Icon(Mdi.wrench),
            title: const Text("Manage shared preferences"),
            onTap: () => context.push('/settings/debug/preferences'),
          ),
          ListTile(
            leading: const Icon(Mdi.key),
            title: const Text("Run OAuth Server"),
            onTap: () => runOAuthServer(launchUrl),
          ),
        ],
      ),
    );
  }
}
