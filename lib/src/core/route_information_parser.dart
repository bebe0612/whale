import 'package:flutter/material.dart';

import 'page_config.dart';

class WhaleRouteInformationParser extends RouteInformationParser<PageConfig> {
  WhaleRouteInformationParser();

  /// called when `system navigator` pushed new route information
  @override
  Future<PageConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    return PageConfig(name: '', view: Container());
  }

  @override
  RouteInformation? restoreRouteInformation(configuration) {
    return super.restoreRouteInformation(configuration);
  }
}
