import 'package:flutter/material.dart';
import 'package:whale/src/core/page_config.dart';

class ViewStack {
  final String viewName;
  final Widget view;
  final List<Page> stack;

  ViewStack(PageConfig pageConfig)
      : viewName = pageConfig.name,
        view = pageConfig.view,
        stack = [pageConfig.toPage()];
}
