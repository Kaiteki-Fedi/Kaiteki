import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";

class AccountSwitcher extends ConsumerWidget {
  final double? size;

  const AccountSwitcher({super.key, this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      iconSize: size ?? 24,
      icon: const AccountIcon(),
      onPressed: () => context.pushNamed("accounts"),
      tooltip: "Switch accounts",
    );
  }
}

class AccountIcon extends ConsumerWidget {
  final double? size;

  const AccountIcon({super.key, this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(currentAccountProvider);

    final size = this.size ?? IconTheme.of(context).size;

    if (account == null) {
      return Icon(
        Icons.account_circle_rounded,
        size: size,
      );
    }

    return AvatarWidget(
      account.user,
      size: size ?? 24.0,
    );
  }
}
