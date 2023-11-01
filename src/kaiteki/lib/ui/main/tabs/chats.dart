part of "tab.dart";

class _ChatsMainScreenTab extends MainScreenTab {
  const _ChatsMainScreenTab();

  @override
  bool isAvailable(BackendAdapter adapter) {
    return adapter.safeCast<ChatSupport>()?.capabilities.supportsChat ?? false;
  }
}
