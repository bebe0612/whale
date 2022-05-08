import 'dart:async';

import 'package:flutter/material.dart';

class WhaleBackButtonDispatcher extends RootBackButtonDispatcher {
  Future<bool> Function()? onBackButtonPressed;
  @override
  Future<bool> didPopRoute() {
    if (onBackButtonPressed != null) {
      return onBackButtonPressed!();
    } else {
      return Future.sync(() => false);
    }
  }
}
