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
  final List<ViewStack> _viewStacks = [];

  bool backButtonEnableYn = true;

  WhaleRouterDelegate({
    required PageConfig initialPage,
    List<NavigatorObserver>? observers,
  })  : _observers = observers ?? [],
        navigatorKey = GlobalKey<NavigatorState>() {
    setNewRoutePath(initialPage);
  }

  final StreamController<RouterState> _backButtonEventController =
      StreamController.broadcast();
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

  List<Page> _convertToPages() {
    List<Page> pages = [];
    for (final viewStack in _viewStacks) {
      pages.addAll(viewStack.stack);
    }

    return pages;
  }

  bool _onPopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }

    if (_viewStacks.length > 1) {
      _viewStacks.removeLast();
    }

    return true;
  }

  @override
  Future<bool> popRoute() {
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

    if (_viewStacks.isEmpty) {
      ViewStack newViewStack = ViewStack(configuration);
      _viewStacks.add(newViewStack);
      notifyListeners();
    } else {
      push(
          targetPageKey: _viewStacks.last.viewName,
          pushedPageConfig: configuration);
    }
    return SynchronousFuture(null);
  }

  String getPath() {
    String path = '';

    for (final viewStack in _viewStacks) {
      path += viewStack.viewName;
    }
    return path;
  }

  String getAllPath() {
    String path = '';

    for (final viewStack in _viewStacks) {
      path += viewStack.viewName;

      for (final dialog in viewStack.stack.sublist(1)) {
        path += (dialog.arguments as PageConfig).name;
      }
    }
    return path;
  }

  void pushAll(List<PageConfig> configurations) {
    List<ViewStack> viewStacks =
        configurations.map((e) => ViewStack(e)).toList();

    for (final viewStack in viewStacks) {
      if (_isViewExist(viewStack.viewName)) {
        return;
      }
    }

    _viewStacks.addAll(viewStacks);

    notifyListeners();
  }

  bool _isViewExist(String viewName) {
    for (final viewStack in _viewStacks) {
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
        _viewStacks.indexWhere((element) => element.viewName == targetPageKey);

    if (viewStackIndex == -1) {
      return;
    }

    ViewStack viewStack = ViewStack(pushedPageConfig);

    if (_viewStacks.length - 1 >= viewStackIndex + 1) {
      _viewStacks.insert(viewStackIndex + 1, viewStack);
    } else {
      _viewStacks.add(viewStack);
    }

    notifyListeners();
  }

  void pop({required String viewName, bool forceYn = false, dynamic argument}) {
    final idx =
        _viewStacks.indexWhere((element) => element.viewName == viewName);

    if (idx == -1) {
      return;
    }
    _viewStacks.removeAt(idx);

    notifyListeners();
  }

  void _popLast() {
    ViewStack last = _viewStacks.last;

    if (last.stack.length > 1) {
      last.stack.removeLast();
    } else {
      _viewStacks.remove(last);
    }

    notifyListeners();
  }

  void popUntil({required String viewName}) {
    final index =
        _viewStacks.indexWhere((element) => element.viewName == viewName);

    if (_viewStacks.length == index + 1) {
      return;
    } else {
      _viewStacks.removeRange(index + 1, _viewStacks.length);
    }
  }

  /// `REPLACE`

  void replace(String targetName, PageConfig to) {
    if (_isViewExist(to.name)) return;

    final targetViewIndex =
        _viewStacks.indexWhere((element) => element.viewName == targetName);

    if (targetViewIndex == -1) {
      return;
    }

    final newViewStack = ViewStack(to);
    _viewStacks.insert(targetViewIndex, newViewStack);
    _viewStacks.removeAt(targetViewIndex + 1);

    notifyListeners();
  }

  void replaceAll(List<PageConfig> configurations) {
    _viewStacks.clear();

    List<ViewStack> viewStacks =
        configurations.map((e) => ViewStack(e)).toList();

    _viewStacks.addAll(viewStacks);

    notifyListeners();
  }

  void showDialog(String targetName, PageConfig dialog) {
    if (!_isViewExist(targetName)) return;

    final targetViewIndex =
        _viewStacks.indexWhere((element) => element.viewName == targetName);

    final viewStack = _viewStacks[targetViewIndex].stack;
    for (final page in viewStack) {
      PageConfig pageConfig = page.arguments as PageConfig;

      if (pageConfig.name == dialog.name) {
        return;
      }
    }

    viewStack.add(dialog.toPage());

    notifyListeners();
  }

  void hideDialog(String targetName, String dialogName) {
    if (!_isViewExist(targetName)) return;

    final targetViewIndex =
        _viewStacks.indexWhere((element) => element.viewName == targetName);

    final viewStack = _viewStacks[targetViewIndex].stack;

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
}
