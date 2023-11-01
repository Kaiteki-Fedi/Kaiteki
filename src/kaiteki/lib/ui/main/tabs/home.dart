part of "tab.dart";

class _HomeMainScreenTab extends MainScreenTab {
  const _HomeMainScreenTab();

  @override
  Widget? buildFab(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return FloatingActionButton.extended(
      icon: const Icon(Icons.edit_rounded),
      tooltip: l10n.composeDialogTitle,
      label: Text(l10n.composeButtonLabel),
      heroTag: "aaa",
      onPressed: () => context.pushNamed(
        "compose",
        pathParameters: ref.accountRouterParams,
      ),
    );
  }
}
