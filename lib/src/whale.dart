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

    _routerDelegate?.navigationStream.listen((viewName) {
      _pageStackChangeStreamController.add(viewName);
    });

    _backButtonDispatcher.onBackButtonPressed = _routerDelegate?.popRoute;

    return _routerDelegate!;
  }

  /// `UTIL`
  // when page stack has event
  static final StreamController<String?> _pageStackChangeStreamController =
      StreamController.broadcast();

  static Stream<String?> get navigationStream =>
      _pageStackChangeStreamController.stream;

  // when user pressed back button
  static final StreamController _backButtonEventStreamController =
      StreamController.broadcast();

  static Stream get backButtonStream => _backButtonEventStreamController.stream;

  /// `SETTING`

  static void activateBackButton(bool value) {
    _routerDelegate?.backButtonEnableYn = value;
  }

  // get all pages information on the stack
  static Uri getPagesFromStack() {
    return Uri.parse(_routerDelegate?.getPath() ?? '');
  }

  static Uri getPagesWithDialogFromStack() {
    return Uri.parse(_routerDelegate?.getAllPath() ?? '');
  }

  static popUntil(Widget view) {
    _routerDelegate?.popUntil(viewName: '/${view.runtimeType.toString()}');
  }

  static String _lastPageName = "/";
  static bool firebaseRouteFilter(Route<dynamic>? route) {
    PageConfig pageConfig = route?.settings.arguments as PageConfig;

    if (!pageConfig.name.contains('/')) return false;

    if (_lastPageName != _routerDelegate?.getLastPageName()) {
      _lastPageName = _routerDelegate!.getLastPageName();

      return true;
    }
    return false;
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
        viewName: '/${view.runtimeType.toString()}',
        forceYn: force,
        argument: argument);
  }

  /// `GO`

  static Future<dynamic> goByContext({
    required BuildContext from,
    required Widget to,
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

  static Future<dynamic> goByWidget({
    required Widget from,
    required Widget to,
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

  static Future<dynamic> goAll({
    Widget? from,
    required List<Widget> views,
  }) async {
    final configurations = views
        .map((e) => PageConfig(name: '/${e.runtimeType.toString()}', view: e))
        .toList();

    return _routerDelegate?.pushAll(
        from != null ? '/${from.runtimeType.toString()}' : null,
        configurations);
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
        .map((e) => PageConfig(
              name: '/${e.runtimeType.toString()}',
              view: e,
              type: views.first == e ? PageType.noAnim : PageType.material,
            ))
        .toList();

    return _routerDelegate?.replaceAll(configurations);
  }

  /// `Dialog`

  static Future<dynamic> showDialog({
    required Widget targetView,
    required Widget dialog,
    required String dialogName,
    double barrierOpacity = 0.3,
  }) async {
    return _routerDelegate?.showDialog(
      '/${targetView.runtimeType.toString()}',
      PageConfig(
        name: '.$dialogName',
        view: dialog,
        type: PageType.dialog,
        argument: {'opacity': barrierOpacity},
      ),
    );
  }

  static Future<dynamic> showDialogByContext({
    required BuildContext context,
    required Widget dialog,
    required String dialogName,
    double barrierOpacity = 0.3,
  }) async {
    PageConfig? pageConfig =
        ModalRoute.of(context)?.settings.arguments as PageConfig;

    return _routerDelegate?.showDialog(
      pageConfig.name,
      PageConfig(
        name: '.$dialogName',
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
        targetView == null ? null : '/${targetView.runtimeType.toString()}',
        '.$dialogName');
  }

  static pushAnyway(
    Widget widget, {
    bool isModal = false,
    bool restrictPop = false,
  }) {
    _routerDelegate?.pushForce(
      pushedPageConfig: PageConfig(
        view: widget,
        name: '/${widget.runtimeType.toString()}',
        type: isModal ? PageType.fullscreen : PageType.material,
        constraint: restrictPop ? PageConstraint.none : PageConstraint.cantPop,
      ),
    );
  }

  static showGlobalPopUp({
    required Widget dialog,
    double barrierOpacity = 0.3,
  }) {
    _routerDelegate?.showGlobalDialog(
      PageConfig(
        name: '@${dialog.runtimeType.toString()}',
        view: dialog,
        type: PageType.dialog,
        argument: {'opacity': barrierOpacity},
      ),
    );
  }

  static hideGlobalPopUp() {
    _routerDelegate?.hideGlobalDialog();
  }
}
