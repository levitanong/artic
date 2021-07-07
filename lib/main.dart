import 'package:artic/routing.dart';
import 'package:artic/stores/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  SettingsStore settingsStore = SettingsStore();
  runApp(ChangeNotifierProvider<SettingsStore>(
      create: (context) => settingsStore, child: App()));
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
    return Consumer<SettingsStore>(builder: (context, settingsStore, child) {
      return MaterialApp.router(
        locale: settingsStore.currentLocale,
        routeInformationParser: _routeInformationParser,
        routerDelegate: _routerDelegate,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      );
    });
  }
}
