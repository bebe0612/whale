import 'package:flutter/widgets.dart';

class NoAnimPage<T> extends Page<T> {
  const NoAnimPage({
    required this.child,
    LocalKey? key,
    String? name,
    Object? arguments,
  }) : super(key: key, name: name, arguments: arguments);

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return NoAnimRoute<T>(
      builder: (context) => child,
      settings: this,
    );
  }
}

class NoAnimRoute<T> extends PageRoute<T> {
  NoAnimRoute({
    required this.builder,
    RouteSettings? settings,
  }) : super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => Color(0xffffffff);

  @override
  String get barrierLabel => 'transparent';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 0);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return result;
  }
}
