part of "tab.dart";

class _BookmarksMainScreenTab extends MainScreenTab {
  const _BookmarksMainScreenTab();

  @override
  bool isAvailable(BackendAdapter adapter) => adapter is BookmarkSupport;
}
