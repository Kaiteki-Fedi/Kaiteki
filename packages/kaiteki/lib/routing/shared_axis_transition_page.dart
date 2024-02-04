import "package:animations/animations.dart";
import "package:flutter/material.dart";

class SharedAxisTransitionPage<T> extends Page<T> {
  const SharedAxisTransitionPage({
    required this.child,
    required this.transitionType,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    this.fillColor,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
  });

  final Widget child;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final bool maintainState;
  final bool fullscreenDialog;
  final bool opaque;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final Color? fillColor;
  final SharedAxisTransitionType transitionType;

  @override
  Route<T> createRoute(BuildContext context) =>
      _SharedAxisTransitionPageRoute<T>(this);
}

class _SharedAxisTransitionPageRoute<T> extends PageRoute<T> {
  _SharedAxisTransitionPageRoute(SharedAxisTransitionPage<T> page)
      : super(settings: page);

  SharedAxisTransitionPage<T> get _page =>
      settings as SharedAxisTransitionPage<T>;

  @override
  bool get barrierDismissible => _page.barrierDismissible;

  @override
  Color? get barrierColor => _page.barrierColor;

  @override
  String? get barrierLabel => _page.barrierLabel;

  @override
  Duration get transitionDuration => _page.transitionDuration;

  @override
  Duration get reverseTransitionDuration => _page.reverseTransitionDuration;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  bool get opaque => _page.opaque;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: _page.child,
      );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: _page.transitionType,
        fillColor: _page.fillColor,
        child: _page.child,
      );
}
