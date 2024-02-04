part of "tab.dart";

class _ExploreMainScreenTab extends MainScreenTab {
  const _ExploreMainScreenTab();

  @override
  bool isAvailable(BackendAdapter adapter) => adapter is ExploreSupport;
}
