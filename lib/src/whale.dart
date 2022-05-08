import 'dart:async';

import 'package:flutter/material.dart';
import 'package:whale/src/core/back_button_dispatcher.dart';
import 'package:whale/src/core/page_config.dart';
import 'package:whale/src/core/route_information_parser.dart';

import 'core/router_delegate.dart';

class Whale {
  Whale._();

  static WhaleRouterDelegate? _routerDelegate;
  static final WhaleBackButtonDispatcher _backButtonDispatcher =
      WhaleBackButtonDispatcher();

  static BackButtonDispatcher getBackButtonDispatcher() =>
      _backButtonDispatcher;

  static RouteInformationParser<PageConfig> getRouteInformationParser() =>
      WhaleRouteInformationParser();

  // initialize
  static RouterDelegate<PageConfig> getRouterDelegate({
    required Widget view,
    List<NavigatorObserver> observers = const [],
  }) {
    if (_routerDelegate != null) {
      return _routerDelegate!;
    }

    _routerDelegate = WhaleRouterDelegate(
      initialPage:
          PageConfig(view: view, name: '/' + view.runtimeType.toString()),
      observers: observers,
    );

    return _routerDelegate!;
  }

  /// `UTIL`
  // when page stack has event
  final StreamController _pageStackChangeStreamController =
      StreamController.broadcast();

  Stream get onPageStackChanged => _pageStackChangeStreamController.stream;

  // when user pressed back button
  final StreamController _backButtonEventStreamController =
      StreamController.broadcast();

  Stream get onBackButtonEventOccur => _backButtonEventStreamController.stream;

  /// `SETTING`

  void activateBackButton(bool value) {
    _routerDelegate?.backButtonEnableYn = value;
  }

  // get all pages information on the stack
  static getPagesFromStack() {
    //
  }

  static popUntilByKey(dynamic pageKey) {
    //
  }

  /// `BACK`

  static backByContext(BuildContext context,
      {dynamic argument, bool force = false}) {
    PageConfig? pageConfig =
        ModalRoute.of(context)?.settings.arguments as PageConfig;

    return _routerDelegate?.pop(
        viewName: pageConfig.name, forceYn: force, argument: argument);
  }

  static backByView(Widget view, {dynamic argument, bool force = false}) {
    return _routerDelegate?.pop(
        viewName: view.runtimeType.toString(),
        forceYn: force,
        argument: argument);
  }

  /// `GO`

  static Future<dynamic> goByContext(
    BuildContext from,
    Widget to, {
    String? viewName,
    bool isModal = false,
    bool restrictPop = false,
  }) async {
    PageConfig? pageConfig =
        ModalRoute.of(from)?.settings.arguments as PageConfig;

    return _routerDelegate?.push(
      targetPageKey: pageConfig.name,
      pushedPageConfig: PageConfig(
        view: to,
        name: viewName ?? '/${to.runtimeType.toString()}',
        type: isModal ? PageType.fullscreen : PageType.material,
        constraint: restrictPop ? PageConstraint.none : PageConstraint.cantPop,
      ),
    );
  }

  static Future<dynamic> goByWidget(
    Widget from,
    Widget to, {
    String? viewName,
    bool isModal = false,
    bool restrictPop = false,
  }) async {
    return _routerDelegate?.push(
      targetPageKey: '/${from.runtimeType.toString()}',
      pushedPageConfig: PageConfig(
        view: to,
        name: viewName ?? '/${to.runtimeType.toString()}',
        type: isModal ? PageType.fullscreen : PageType.material,
        constraint: restrictPop ? PageConstraint.none : PageConstraint.cantPop,
      ),
    );
  }

  /// `REPLACE`

  static Future<dynamic> replaceByWidget({
    required Widget from,
    required Widget to,
    bool restrictPop = false,
  }) async {
    return _routerDelegate?.replace(
        '/${from.runtimeType.toString()}',
        PageConfig(
          name: '/${to.runtimeType.toString()}',
          view: to,
          type: PageType.noAnim,
          constraint:
              restrictPop ? PageConstraint.none : PageConstraint.cantPop,
        ));
  }

  static Future<dynamic> replaceByContext({
    required BuildContext from,
    required Widget to,
    bool restrictPop = false,
  }) async {
    PageConfig? pageConfig =
        ModalRoute.of(from)?.settings.arguments as PageConfig;

    return _routerDelegate?.replace(
        pageConfig.name,
        PageConfig(
          name: '/${to.runtimeType.toString()}',
          view: to,
          type: PageType.noAnim,
          constraint:
              restrictPop ? PageConstraint.none : PageConstraint.cantPop,
        ));
  }

  static Future<dynamic> replaceAll({required List<Widget> views}) async {
    final configurations = views
        .map((e) => PageConfig(name: '/${e.runtimeType.toString()}', view: e))
        .toList();

    return _routerDelegate?.replaceAll(configurations);
  }

  /// `Dialog`

  static Future<dynamic> showDialog({
    Widget? targetView,
    required Widget dialog,
    required String dialogName,
    double barrierOpacity = 0.3,
  }) async {
    return _routerDelegate?.showDialog(
      '/${targetView.runtimeType.toString()}',
      PageConfig(
        name: dialogName,
        view: dialog,
        type: PageType.dialog,
        argument: {'opacity': barrierOpacity},
      ),
    );
  }

  static Future<void> hideDialog({
    Widget? targetView,
    required String dialogName,
  }) async {
    _routerDelegate?.hideDialog(
        '/${targetView.runtimeType.toString()}', dialogName);
  }

  static pushAnyway(Widget widget) {
    //
  }
}
