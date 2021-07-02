import 'package:artic/routing.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  ArticRouteInformationParser _routeInformationParser =
      ArticRouteInformationParser();
  ArticRouterDelegate _routerDelegate = ArticRouterDelegate();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routeInformationParser: _routeInformationParser,
        routerDelegate: _routerDelegate);
  }
}
