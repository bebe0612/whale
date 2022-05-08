import 'package:flutter_test/flutter_test.dart';
import 'package:whale/src/core/page_config.dart';
import 'package:whale/src/core/router_delegate.dart';

import '../mock/test_view.dart';

void main() {
  group('Push Test', () {
    WhaleRouterDelegate routerDelegate = WhaleRouterDelegate(
        initialPage: PageConfig(name: '/home', view: const HomeView()));
    test('initialView', () {
      expect('/home', routerDelegate.getPath());
    });

    test('push', () {
      routerDelegate.push(
          targetPageKey: '/home',
          pushedPageConfig: PageConfig(name: '/user', view: const UserView()));

      expect('/home/user', routerDelegate.getPath());
    });

    test('push same name will fail', () {
      routerDelegate.push(
          targetPageKey: '/home',
          pushedPageConfig: PageConfig(name: '/user', view: const UserView()));

      expect('/home/user', routerDelegate.getPath());
    });

    test('push to target view', () {
      routerDelegate.push(
          targetPageKey: '/home',
          pushedPageConfig:
              PageConfig(name: '/setting', view: const SettingView()));

      expect('/home/setting/user', routerDelegate.getPath());
    });

    test('pop target view', () {
      routerDelegate.pop(viewName: '/setting');

      expect('/home/user', routerDelegate.getPath());

      routerDelegate.pop(viewName: '/user');

      expect('/home', routerDelegate.getPath());
    });

    test('replace', () {
      routerDelegate.replace(
          '/home', PageConfig(name: '/user', view: const UserView()));

      expect('/user', routerDelegate.getPath());

      routerDelegate.replace(
          '/user', PageConfig(name: '/home', view: const HomeView()));

      expect('/home', routerDelegate.getPath());
    });

    test('push all', () {
      routerDelegate.pushAll('/home', [
        PageConfig(
          name: '/user',
          view: const UserView(),
        ),
        PageConfig(
          name: '/setting',
          view: const SettingView(),
        ),
      ]);

      expect(routerDelegate.getPath(), '/home/user/setting');
    });

    test('replace all', () {
      routerDelegate.replaceAll([
        PageConfig(
          name: '/user',
          view: const UserView(),
        ),
        PageConfig(
          name: '/setting',
          view: const SettingView(),
        ),
      ]);

      expect('/user/setting', routerDelegate.getPath());
    });

    test('pop until', () {
      routerDelegate.push(
          targetPageKey: '/setting',
          pushedPageConfig: PageConfig(name: '/home', view: const HomeView()));

      expect('/user/setting/home', routerDelegate.getPath());

      routerDelegate.popUntil(viewName: '/user');

      expect('/user', routerDelegate.getPath());
    });
  });

  group('Dialog Test', () {
    WhaleRouterDelegate routerDelegate = WhaleRouterDelegate(
        initialPage: PageConfig(name: '/home', view: const HomeView()));

    test('show dialog', () {
      routerDelegate.showDialog(
          '/home',
          PageConfig(
            name: '.fail-dialog',
            view: const FailDialog(),
            type: PageType.dialog,
          ));

      expect('/home.fail-dialog', routerDelegate.getAllPath());
    });

    test('hide dialog', () {
      routerDelegate.hideDialog('/home', '.fail-dialog');

      expect('/home', routerDelegate.getAllPath());
    });
  });
}
