import 'package:example/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:whale/whale.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: Whale.getRouteInformationParser(),
      routerDelegate:
          Whale.getRouterDelegate(view: const HomeView(), observers: []),
      backButtonDispatcher: Whale.getBackButtonDispatcher(),
    );
  }
}
