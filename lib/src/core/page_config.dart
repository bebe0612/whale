import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whale/src/pages/slide_right_page.dart';

import '../pages/no_anim_page.dart';
import '../pages/pop_up_page.dart';

enum PageType {
  material,
  fullscreen,
  noAnim,
  dialog,
  notification,
  slideRight,
}

enum PageConstraint {
  none,
  cantPop,
}

class PageConfig {
  final String name;
  final Widget view;
  final PageType type;
  final PageConstraint? constraint;
  final Map<String, dynamic> argument;
  PageConfig({
    required this.name,
    required this.view,
    this.type = PageType.material,
    this.constraint = PageConstraint.none,
    this.argument = const {},
  });

  Page toPage() {
    PageType _type = type;

    if (Platform.isAndroid && type == PageType.material) {
      _type = PageType.slideRight;
    }

    switch (_type) {
      case PageType.material:
        return MaterialPage(
          child: view,
          key: ValueKey(name),
          name: name,
          arguments: this,
        );
      case PageType.dialog:
        return PopUpPage(
          child: view,
          key: ValueKey(name),
          name: name,
          arguments: this,
          fullscreenDialog: true,
          opacity: argument['opacity'],
        );
      case PageType.noAnim:
        return NoAnimPage(
          child: view,
          key: ValueKey(name),
          name: name,
          arguments: this,
        );
      case PageType.fullscreen:
        return MaterialPage(
          child: view,
          key: ValueKey(name),
          name: name,
          arguments: this,
          fullscreenDialog: true,
        );
      case PageType.notification:
        return PopUpPage(
          child: view,
          key: ValueKey(name),
          name: name,
          arguments: this,
          fullscreenDialog: true,
          opacity: argument['opacity'],
        );
      case PageType.slideRight:
        return SlideRightPage(
          child: view,
          key: ValueKey(name),
          name: name,
          arguments: this,
          opacity: argument['opacity'],
        );
      default:
        return MaterialPage(
          child: view,
          key: ValueKey(name),
          name: name,
          arguments: this,
          fullscreenDialog: false,
        );
    }
  }
}
