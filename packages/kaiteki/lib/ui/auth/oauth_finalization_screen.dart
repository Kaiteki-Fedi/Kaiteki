import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";
import "package:kaiteki_core/utils.dart";
import "package:kaiteki_core_backends/kaiteki_core_backends.dart";

class OAuthFinalizationScreen extends ConsumerStatefulWidget {
  final BackendType type;
  final String host;
  final Map<String, String>? extra;
  final Map<String, String> query;

  const OAuthFinalizationScreen({
    super.key,
    required this.type,
    required this.host,
    this.extra,
    required this.query,
  });

  @override
  ConsumerState<OAuthFinalizationScreen> createState() =>
      _OAuthFinalizationScreenState();
}

class _OAuthFinalizationScreenState
    extends ConsumerState<OAuthFinalizationScreen> {
  @override
  void initState() {
    super.initState();
    finalizeOAuth().then((success) {
      if (success) return;

      final goRouter = GoRouter.of(context);

      if (!goRouter.canPop()) {
        goRouter.go("/");
        return;
      }

      goRouter.pop();
    });
  }

  Future<bool> finalizeOAuth() async {
    final router = GoRouter.of(context);
    final accountManager = ref.read(accountManagerProvider.notifier);
    final BackendAdapter adapter;

    try {
      adapter = await widget.type.createAdapter(widget.host);
    } catch (e, s) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => OAuthFailureDialog.error(error: (e, s)),
        );
      }

      return false;
    }

    final receiver = adapter as OAuthReceiver;

    final result = await receiver.handleOAuth(widget.query, widget.extra);
    if (result is! LoginSuccess) {
      if (result is LoginFailure && mounted) {
        await showDialog(
          context: context,
          builder: (context) {
            return OAuthFailureDialog.loginFailure(result: result);
          },
        );
      }

      return false;
    }

    final instance = await adapter.getInstance();

    final account = Account.fromLoginResult(
      result,
      adapter,
      widget.type,
      widget.host,
      instance: instance,
    );

    await accountManager.add(account);
    router.goNamed("home", pathParameters: account.key.routerParams);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text("Signing in..."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OAuthFailureDialog extends StatelessWidget {
  const OAuthFailureDialog.loginFailure({
    super.key,
    required LoginFailure this.result,
  }) : error = null;

  const OAuthFailureDialog.error({
    super.key,
    required TraceableError this.error,
  }) : result = null;

  final LoginFailure? result;
  final TraceableError? error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Couldn't finish OAuth"),
      content: Text(
        error == null
            ? "Authentication has failed."
            : "An error occurred while initializing the adapter.",
      ),
      actions: [
        TextButton(
          onPressed: () => context.showExceptionDialog(error ?? result!.error),
          child: Text(context.l10n.showDetailsButtonLabel),
        ),
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(context.materialL10n.okButtonLabel),
        ),
      ],
    );
  }
}
