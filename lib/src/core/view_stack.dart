import 'package:flutter/material.dart';
import 'package:whale/src/core/page_config.dart';

class WhaleScreen {
  final String viewName;
  final Widget view;
  final List<Page> pages;

  WhaleScreen(PageConfig pageConfig)
      : viewName = pageConfig.name,
        view = pageConfig.view,
        pages = [pageConfig.toPage()];
}
