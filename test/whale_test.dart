import 'package:flutter_test/flutter_test.dart';
import 'package:whale/whale.dart';

import 'mock/test_view.dart';

void main() {
  test('Init', () {
    Whale.getRouterDelegate(view: const HomeView());

    expect(Whale.getPagesFromStack().pathSegments, ['HomeView']);
  });

  test('Go', () {
    Whale.goByWidget(from: const HomeView(), to: const UserView());

    expect(Whale.getPagesFromStack().pathSegments, ['HomeView', 'UserView']);
  });

  test('Go Target', () {
    Whale.goByWidget(from: const HomeView(), to: const SettingView());

    expect(Whale.getPagesFromStack().pathSegments,
        ['HomeView', 'SettingView', 'UserView']);
  });

  test('Back 01', () {
    Whale.backByView(const SettingView());

    expect(Whale.getPagesFromStack().pathSegments, ['HomeView', 'UserView']);
  });
  test('Back 02', () {
    Whale.backByView(const UserView());

    expect(Whale.getPagesFromStack().pathSegments, ['HomeView']);
  });

  test('Replace', () {
    Whale.replaceByWidget(from: const HomeView(), to: const UserView());

    expect(Whale.getPagesFromStack().pathSegments, ['UserView']);
  });

  test('show dialog', () {
    Whale.showDialog(
      targetView: const UserView(),
      dialog: const FailDialog(),
      dialogName: 'fail-dialog',
    );

    expect(Whale.getPagesWithDialogFromStack().path, '/UserView.fail-dialog');
  });

  test('hide dialog', () {
    Whale.hideDialog(targetView: const UserView(), dialogName: 'fail-dialog');

    expect(Whale.getPagesWithDialogFromStack().path, '/UserView');
  });

  test('hide dialog at global search', () {
    Whale.showDialog(
      targetView: const UserView(),
      dialog: const FailDialog(),
      dialogName: 'fail-dialog',
    );

    expect(Whale.getPagesWithDialogFromStack().path, '/UserView.fail-dialog');

    Whale.hideDialog(dialogName: 'fail-dialog');

    expect(Whale.getPagesWithDialogFromStack().path, '/UserView');
  });
}
