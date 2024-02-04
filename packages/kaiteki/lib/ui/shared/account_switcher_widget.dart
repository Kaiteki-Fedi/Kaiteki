import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";

class AccountSwitcherWidget extends ConsumerWidget {
  final double? size;

  const AccountSwitcherWidget({super.key, this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      iconSize: size ?? 24,
      icon: buildIcon(context, ref),
      onPressed: () => context.pushNamed("accounts"),
    );
  }

  Widget buildIcon(BuildContext context, WidgetRef ref) {
    final account = ref.watch(currentAccountProvider);

    if (account == null) {
      return const Icon(Icons.account_circle_rounded);
    }

    return AvatarWidget(account.user, size: size ?? 24);
  }
}
