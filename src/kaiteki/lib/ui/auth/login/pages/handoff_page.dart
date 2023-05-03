import "dart:convert";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account_key.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:kaiteki/ui/auth/transit_account.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart";
import "package:tuple/tuple.dart";

class HandoffPage extends StatefulWidget {
  const HandoffPage({super.key});

  @override
  State<HandoffPage> createState() => _HandoffPageState();
}

class _HandoffPageState extends State<HandoffPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign in with another device"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Open the account list on your other device and tap the device icon. Please note to do this alone as the QR code will give access to your account.",
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        shape: BoxShape.circle,
                      ),
                      child: const SizedBox(width: 32, height: 32),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          child: const SizedBox(width: 128, height: 8),
                        ),
                        const SizedBox(height: 8),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          child: const SizedBox(width: 64, height: 8),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      Icons.devices_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface,
                        shape: BoxShape.circle,
                      ),
                      child: const SizedBox(width: 24, height: 24),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, _) {
                return FilledButton.icon(
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: const Text("Scan QR code"),
                  onPressed: () {
                    QrBarCodeScannerDialog().getScannedQrBarCode(
                      context: context,
                      onCode: (p0) async {
                        if (p0 == null) return;
                        final json = jsonDecode(p0);
                        if (json is! Map<String, dynamic>) {
                          return;
                        }

                        final transitAccount = TransitAccount.fromJson(json);
                        final accountManager = ref.read(accountManagerProvider);
                        final accountKey = AccountKey(
                          transitAccount.apiType,
                          transitAccount.instance,
                          transitAccount.username,
                        );
                        final accountSecret = AccountSecret(
                          transitAccount.accessToken,
                          transitAccount.refreshToken,
                          transitAccount.userId,
                        );
                        ClientSecret? clientSecret;

                        if (transitAccount.clientId != null &&
                            transitAccount.clientSecret != null) {
                          clientSecret = ClientSecret(
                            transitAccount.clientId!,
                            transitAccount.clientSecret!,
                          );
                        }

                        final account = await accountManager.restoreSession(
                          Tuple3(
                            accountKey,
                            accountSecret,
                            clientSecret,
                          ),
                        );

                        if (account == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to restore account"),
                            ),
                          );
                          return;
                        }

                        await accountManager.add(account);

                        context.goNamed(
                          "home",
                          pathParameters: account.key.routerParams,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
