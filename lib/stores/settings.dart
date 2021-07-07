import 'package:flutter/material.dart';

class SettingsStore extends ChangeNotifier {
  Locale? _currentLocale;
  Locale? get currentLocale => _currentLocale;

  set currentLocale(Locale? l) {
    _currentLocale = l;
    notifyListeners();
  }
}
