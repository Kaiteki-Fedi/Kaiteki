import "package:kaiteki/ui/main/fab_data.dart";
import "package:kaiteki/ui/main/tab_kind.dart";

class MainScreenTab {
  final FloatingActionButtonData? fab;
  final bool hideFabWhenDesktop;
  final TabKind kind;
  final int? Function()? fetchUnreadCount;

  const MainScreenTab(
    this.kind, {
    this.fab,
    this.hideFabWhenDesktop = false,
    this.fetchUnreadCount,
  });
}
