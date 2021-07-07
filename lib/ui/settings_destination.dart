import 'package:artic/stores/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsDestination extends StatefulWidget {
  const SettingsDestination({Key? key}) : super(key: key);

  @override
  _SettingsDestinationState createState() => _SettingsDestinationState();
}

class _SettingsDestinationState extends State<SettingsDestination> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsStore>(builder: (context, settingsStore, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
          ),
          body: Container(
            child: DropdownButton<Locale>(
              value: settingsStore.currentLocale,
              items: [
                DropdownMenuItem<Locale>(
                    child: Text('English'),
                    key: Key('en'),
                    value: Locale('en')),
                DropdownMenuItem<Locale>(
                    child: Text('Tagalog'), key: Key('en'), value: Locale('tl'))
              ],
              onChanged: (Locale? locale) {
                settingsStore.currentLocale = locale;
              },
            ),
          ));
    });
  }
}
