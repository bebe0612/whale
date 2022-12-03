import 'package:flutter/material.dart';
import 'package:whale/whale.dart';

class SlideRightPage<T> extends Page<T> {
  const SlideRightPage({
    required this.child,
    this.maintainState = true,
    LocalKey? key,
    String? name,
    Object? arguments,
    double? opacity,
  })  : opacity = opacity,
        super(key: key, name: name, arguments: arguments);

  final double? opacity;

  final Widget child;

  /// {@macro flutter.widgets.ModalRoute.maintainState}
  final bool maintainState;

  @override
  Route<T> createRoute(BuildContext context) {
    return TransparentRoute<T>(
      builder: (context) => child,
      settings: this,
      opacity: opacity ?? .7,
    );
  }
}

class TransparentRoute<T> extends PageRoute<T> {
  TransparentRoute({
    required this.builder,
    RouteSettings? settings,
    required double opacity,
  })  : opacity = opacity,
        super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;
  final double opacity;
  @override
  bool get opaque => false;

  @override
  Color get barrierColor => const Color(0x00ffffff);

  @override
  String get barrierLabel => 'transparent';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);

    CurvedAnimation curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: animation.status == AnimationStatus.reverse
            ? Curves.easeInQuint
            : Curves.easeOutQuint);

    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: AnimatedBuilder(
          animation: animation,
          builder: (context, snapshot) {
            return GestureDetector(
              onTap: () {},
              child: Material(
                color: Colors.transparent,
                elevation: 0,
                child: Transform.translate(
                  offset: Offset(
                      0,
                      MediaQuery.of(context).size.height *
                          (1 - (curvedAnimation.value * 1))),
                  child: result,
                ),
              ),
            );
          }),
    );
  }
}
