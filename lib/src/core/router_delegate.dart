import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whale/src/core/view_stack.dart';

import 'router_state.dart';
import 'page_config.dart';

class WhaleRouterDelegate extends RouterDelegate<PageConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfig> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final List<NavigatorObserver> _observers;
  final List<WhaleScreen> _screens = [];
  final List<Page> _global = [];

  bool backButtonEnableYn = true;

  WhaleRouterDelegate({
    required PageConfig initialPage,
    List<NavigatorObserver>? observers,
  })  : _observers = observers ?? [],
        navigatorKey = GlobalKey<NavigatorState>() {
    setNewRoutePath(initialPage);
  }

  final StreamController<RouterState> _backButtonEventController =
      StreamController();
  Stream<RouterState> get getNewBackButtonEvent =>
      _backButtonEventController.stream;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      observers: _observers,
      pages: _convertToPages(),
    );
  }

  final StreamController<String?> _navigationStreamController =
      StreamController.broadcast();

  Stream<String?> get navigationStream => _navigationStreamController.stream;

  String? _currentName;

  List<Page> _convertToPages() {
    List<Page> pages = [];
    for (final viewStack in _screens) {
      pages.addAll(viewStack.pages);
    }

    if (_currentName != _screens.last.viewName) {
      _currentName = _screens.last.viewName;
      _navigationStreamController.add(_currentName);
    }

    return pages + _global;
  }

  bool _onPopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }

    if (_screens.length > 1) {
      _screens.removeLast();
    }

    return true;
  }

  @override
  Future<bool> popRoute() {
    _backButtonEventController
        .add(RouterState(pageStackUri: Uri.parse(getPath())));

    if (backButtonEnableYn) {
      _popLast();
    }

    return Future.value(true);
  }

  @override
  Future<void> setNewRoutePath(PageConfig configuration) {
    if (configuration.name.isEmpty) {
      return SynchronousFuture(null);
    }

    if (_screens.isEmpty) {
      WhaleScreen newViewStack = WhaleScreen(configuration);
      _screens.add(newViewStack);
      notifyListeners();
    } else {
      push(
          targetPageKey: _screens.last.viewName,
          pushedPageConfig: configuration);
    }
    return SynchronousFuture(null);
  }

  String getPath() {
    String path = '';

    for (final viewStack in _screens) {
      for (var item in viewStack.pages) {
        path += item.name ?? ".undefine";
      }
    }
    return path;
  }

  String getLastPageName() {
    return _screens.last.viewName;
  }

  String getAllPath() {
    String path = '';

    for (final viewStack in _screens) {
      path += viewStack.viewName;

      for (final dialog in viewStack.pages.sublist(1)) {
        path += (dialog.arguments as PageConfig).name;
      }
    }
    return path;
  }

  void pushAll(String? viewName, List<PageConfig> configurations) {
    List<WhaleScreen> viewStacks =
        configurations.map((e) => WhaleScreen(e)).toList();

    for (final viewStack in viewStacks) {
      if (_isViewExist(viewStack.viewName)) {
        return;
      }
    }

    if (viewName != null) {
      if (!_isViewExist(viewName)) {
        return;
      }

      final viewStackIndex =
          _screens.indexWhere((element) => element.viewName == viewName);

      _screens.insertAll(viewStackIndex + 1, viewStacks);
      notifyListeners();
      return;
    }

    _screens.addAll(viewStacks);

    notifyListeners();
  }

  bool _isViewExist(String viewName) {
    for (final viewStack in _screens) {
      if (viewStack.viewName == viewName) {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> push(
      {required String targetPageKey,
      required PageConfig pushedPageConfig}) async {
    if (_isViewExist(pushedPageConfig.name)) return;

    final viewStackIndex =
        _screens.indexWhere((element) => element.viewName == targetPageKey);

    if (viewStackIndex == -1) {
      return;
    }

    WhaleScreen viewStack = WhaleScreen(pushedPageConfig);

    if (_screens.length - 1 >= viewStackIndex + 1) {
      _screens.insert(viewStackIndex + 1, viewStack);
    } else {
      _screens.add(viewStack);
    }

    notifyListeners();
  }

  Future<dynamic> pushForce({required PageConfig pushedPageConfig}) async {
    if (_isViewExist(pushedPageConfig.name)) return;

    WhaleScreen viewStack = WhaleScreen(pushedPageConfig);

    _screens.add(viewStack);

    notifyListeners();
  }

  void pop({required String viewName, bool forceYn = false, dynamic argument}) {
    final idx = _screens.indexWhere((element) => element.viewName == viewName);

    if (idx == -1) {
      return;
    }
    _screens.removeAt(idx);

    notifyListeners();
  }

  void _popLast() {
    WhaleScreen last = _screens.last;

    if (last.pages.length > 1) {
      last.pages.removeLast();
    } else {
      if (_screens.length > 1) {
        _screens.remove(last);
      }
    }

    notifyListeners();
  }

  void popUntil({required String viewName}) {
    final index =
        _screens.indexWhere((element) => element.viewName == viewName);

    if (_screens.length == index + 1) {
      return;
    } else {
      _screens.removeRange(index + 1, _screens.length);
    }
    notifyListeners();
  }

  /// `REPLACE`

  void replace(String targetName, PageConfig to) {
    if (_isViewExist(to.name)) return;

    final targetViewIndex =
        _screens.indexWhere((element) => element.viewName == targetName);

    if (targetViewIndex == -1) {
      return;
    }

    final newViewStack = WhaleScreen(to);
    _screens.insert(targetViewIndex, newViewStack);
    _screens.removeAt(targetViewIndex + 1);

    notifyListeners();
  }

  void replaceAll(List<PageConfig> configurations) {
    _screens.clear();

    List<WhaleScreen> viewStacks =
        configurations.map((e) => WhaleScreen(e)).toList();

    _screens.addAll(viewStacks);

    notifyListeners();
  }

  void showDialog(String targetName, PageConfig dialog) {
    if (!_isViewExist(targetName)) return;

    dialog.argument["parent"] = targetName;

    final targetViewIndex =
        _screens.indexWhere((element) => element.viewName == targetName);

    final viewStack = _screens[targetViewIndex].pages;
    for (final page in viewStack) {
      PageConfig pageConfig = page.arguments as PageConfig;

      if (pageConfig.name == dialog.name) {
        return;
      }
    }

    viewStack.add(dialog.toPage());

    notifyListeners();
  }

  void hideDialog(String? targetName, String dialogName) {
    if (targetName != null && !_isViewExist(targetName)) return;

    if (targetName == null) {
      for (final viewStack in _screens.reversed) {
        for (final page in viewStack.pages) {
          final pageConfig = page.arguments as PageConfig;
          if (pageConfig.name == dialogName) {
            viewStack.pages.remove(page);
            notifyListeners();
            return;
          }
        }
      }
    }

    final targetViewIndex =
        _screens.indexWhere((element) => element.viewName == targetName);

    final viewStack = _screens[targetViewIndex].pages;

    int targetIdx = -1;
    for (int i = 0; i < viewStack.length; i++) {
      PageConfig pageConfig = viewStack[i].arguments as PageConfig;

      if (pageConfig.name == dialogName) {
        targetIdx = i;
        break;
      }
    }

    if (targetIdx != -1) {
      viewStack.removeAt(targetIdx);
    }

    notifyListeners();
  }

  void showGlobalDialog(PageConfig dialog) {
    _global.add(dialog.toPage());

    notifyListeners();
  }

  void hideGlobalDialog() {
    _global.clear();

    notifyListeners();
  }
}
