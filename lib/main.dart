import 'package:artic/routing.dart';
import 'package:artic/stores/main.dart';
import 'package:artic/stores/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  SettingsStore settingsStore = SettingsStore();
  MainStore mainStore = MainStore();
  final app = MultiProvider(providers: [
    ChangeNotifierProvider<MainStore>(create: (context) => mainStore)
  ], child: App());
  runApp(app);
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  ArticRouteInformationParser _routeInformationParser =
      ArticRouteInformationParser();
  late ArticRouterDelegate _routerDelegate;

  @override
  void initState() {
    final mainStore = Provider.of<MainStore>(context, listen: false);
    _routerDelegate = ArticRouterDelegate(mainStore);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MainStore, Locale?>(selector: (context, mainStore) {
      return mainStore.currentLocale;
    }, builder: (context, currentLocale, child) {
      return MaterialApp.router(
        locale: currentLocale,
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
