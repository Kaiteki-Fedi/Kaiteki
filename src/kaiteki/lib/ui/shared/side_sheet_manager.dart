import "package:flutter/material.dart";

class SideSheetManager extends StatefulWidget {
  final Widget Function(Widget? sideSheet) builder;

  const SideSheetManager({
    super.key,
    required this.builder,
  });

  static SideSheetManagerState? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SideSheetManagerScope>()
        ?.state;
  }

  @override
  State<SideSheetManager> createState() => SideSheetManagerState();
}

class SideSheetManagerState extends State<SideSheetManager> {
  Widget? sideSheet;

  @override
  Widget build(BuildContext context) {
    return _SideSheetManagerScope(
      state: this,
      child: widget.builder(sideSheet),
    );
  }

  void openSideSheet({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    sideSheet = WillPopScope(
      onWillPop: () {
        setState(() => sideSheet = null);
        return Future.value(true);
      },
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
        child: builder(context),
      ),
    );

    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scaffold.of(context).openEndDrawer();
    });
  }
}

class _SideSheetManagerScope extends InheritedWidget {
  final SideSheetManagerState state;

  const _SideSheetManagerScope({
    required super.child,
    required this.state,
  });

  @override
  bool updateShouldNotify(_SideSheetManagerScope oldWidget) {
    return state != oldWidget.state;
  }
}
