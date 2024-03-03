import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/notifications.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "account_switcher.g.dart";

@Riverpod(dependencies: [NotificationService, currentAccount, AccountManager])
bool _unreadNotificationsOnAlts(_UnreadNotificationsOnAltsRef ref) {
  final currentKey = ref.watch(currentAccountProvider)?.key;
  final accounts = ref.watch(
    accountManagerProvider.select(
      (e) => e.accounts //
          .where((e) => e.key != currentKey)
          .map((e) => e.key),
    ),
  );

  return accounts.any((e) {
    return ref.watch(
      notificationServiceProvider(e).select(
        (e) => e.valueOrNull?.items.any((e) => e.unread == true) == true,
      ),
    );
  });
}

class AccountSwitcher extends ConsumerWidget {
  final double? size;

  const AccountSwitcher({super.key, this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget icon = const AccountIcon();

    if (ref.watch(_unreadNotificationsOnAltsProvider)) {
      icon = Badge(child: icon);
    }

    return IconButton(
      iconSize: size ?? 24,
      icon: icon,
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
