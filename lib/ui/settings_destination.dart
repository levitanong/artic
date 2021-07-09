import 'package:artic/stores/main.dart';
import 'package:artic/stores/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Primarily a convenience class for collecting
/// settings related data into a non-tuple form.
class SettingsProps {
  Locale? currentLocale;
  SettingsProps({this.currentLocale});
}

class SettingsDestination extends StatefulWidget {
  const SettingsDestination({Key? key}) : super(key: key);

  @override
  _SettingsDestinationState createState() => _SettingsDestinationState();
}

class _SettingsDestinationState extends State<SettingsDestination> {
  @override
  Widget build(BuildContext context) {
    final mainStore = Provider.of<MainStore>(context, listen: false);
    return Selector<MainStore, SettingsProps>(selector: (context, mainStore) {
      return SettingsProps(currentLocale: mainStore.currentLocale);
    }, builder: (context, settingsProps, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
          ),
          body: Container(
            child: DropdownButton<Locale>(
              value: settingsProps.currentLocale,
              items: [
                DropdownMenuItem<Locale>(
                    child: Text('English'),
                    key: Key('en'),
                    value: Locale('en')),
                DropdownMenuItem<Locale>(
                    child: Text('Tagalog'), key: Key('en'), value: Locale('tl'))
              ],
              onChanged: (Locale? locale) {
                mainStore.currentLocale = locale;
              },
            ),
          ));
    });
  }
}
