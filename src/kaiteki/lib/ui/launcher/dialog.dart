import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/utils.dart";
import "package:kaiteki_core/social.dart";
import "package:logging/logging.dart";

typedef _FetchContext = ({
  NavigatorState navigator,
  GoRouter router,
  ScaffoldMessengerState messenger,
});

class LauncherDialog extends ConsumerStatefulWidget {
  const LauncherDialog({super.key});

  @override
  ConsumerState<LauncherDialog> createState() => _LauncherDialogState();
}

class _LauncherDialogState extends ConsumerState<LauncherDialog> {
  Future? _future;

  static final _logger = Logger("Launcher");

  @override
  Widget build(BuildContext context) {
    // evil hacks for snacks
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                final cs = snapshot.connectionState;
                final isInactive = cs == ConnectionState.none;
                final isSuccess =
                    cs == ConnectionState.done && snapshot.data == true;
                final isRunning = !(isInactive || isSuccess);
                return PopScope(
                  canPop: !(cs == ConnectionState.waiting ||
                      cs == ConnectionState.active),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedOpacity(
                        opacity: isRunning ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.fastOutSlowIn,
                        child: buildHeader(context),
                      ),
                      Material(
                        clipBehavior: Clip.antiAlias,
                        shape: const StadiumBorder(),
                        elevation: 8.0,
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            reverseDuration: const Duration(milliseconds: 100),
                            switchInCurve: Curves.easeInCirc,
                            child: isRunning
                                ? const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: SizedBox.square(
                                      dimension: 24,
                                      child: CircularProgressIndicator(
                                        strokeCap: StrokeCap.round,
                                      ),
                                    ),
                                  )
                                : CallbackShortcuts(
                                    bindings: {
                                      const SingleActivator(
                                        LogicalKeyboardKey.escape,
                                      ): () => Navigator.of(context).maybePop(),
                                    },
                                    child: TextField(
                                      autofocus: true,
                                      textInputAction: TextInputAction.go,
                                      decoration: const InputDecoration(
                                        hintText:
                                            "Enter a search term, user handle, or URL from the Fediverse...",
                                        border: InputBorder.none,
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 16,
                                        ),
                                        fillColor: Colors.transparent,
                                      ),
                                      onSubmitted: (query) {
                                        if (query.isEmpty) return;
                                        setState(() {
                                          _future = _onSubmitted(query);
                                        });
                                      },
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onSubmitted(String query) async {
    final navigator = Navigator.of(context);
    final goRouter = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final fetchContext = (
        navigator: navigator,
        router: goRouter,
        messenger: messenger,
      );

      final uri = Uri.tryParse(query);
      if (uri != null && uri.isAbsolute && uri.scheme.isNotEmpty) {
        await openUrl(fetchContext, uri).catchError(
          (e, s) => _logger.warning("Failed to resolve URL", e, s),
        );
        return true;
      }

      final handle = parseUserHandle(query);
      if (handle != null) {
        final currentHost = ref.read(currentAccountProvider)!.key.host;

        final userHandle = UserHandle(handle.$1, handle.$2 ?? currentHost);
        await lookUpUser(fetchContext, userHandle).catchError(
          (e, s) => _logger.warning("Failed to lookup user $userHandle", e, s),
        );

        return true;
      }

      navigator.pop();
      goRouter.pushNamed(
        "search",
        pathParameters: ref.accountRouterParams,
        queryParameters: {"q": query},
      );
      return true;
    } catch (_) {
      navigator.pop();
      return false;
    }
  }

  Column buildHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(
                Icons.keyboard_double_arrow_right_rounded,
                color: Colors.white,
                shadows: [
                  Shadow(blurRadius: 8.0, offset: Offset(0, 2)),
                ],
              ),
              const SizedBox(width: 8),
              Text(
                "Launcher",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  shadows: [
                    const Shadow(blurRadius: 8.0, offset: Offset(0, 2)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Future<void> lookUpUser(_FetchContext fetchContext, UserHandle handle) async {
    fetchContext.messenger.showSnackBar(
      const SnackBar(content: Text("Looking up user...")),
    );

    final adapter = ref.read(adapterProvider);
    final user = await adapter.getUser(handle.username, handle.host);

    if (user == null) {
      fetchContext.messenger.showSnackBar(
        const SnackBar(content: Text("User not found")),
      );
      return;
    }

    fetchContext.navigator.pop();

    fetchContext.router.pushNamed(
      "user",
      pathParameters: {...ref.accountRouterParams, "id": user.id},
    );
  }

  Future<void> openUrl(_FetchContext fetchContext, Uri url) async {
    final adapter = ref.read(adapterProvider);
    final object = await adapter.resolveUrl(url);
    switch (object) {
      case final User user:
        fetchContext.navigator.pop();
        fetchContext.router.pushNamed(
          "user",
          pathParameters: {...ref.accountRouterParams, "id": user.id},
        );
        break;

      case final Post post:
        fetchContext.navigator.pop();
        fetchContext.router.pushNamed(
          "post",
          pathParameters: {...ref.accountRouterParams, "id": post.id},
          extra: post,
        );
        break;

      case null:
        fetchContext.messenger.showSnackBar(
          const SnackBar(content: Text("Couldn't resolve URL")),
        );
        break;

      default:
        throw UnimplementedError(object.toString());
    }
  }
}
