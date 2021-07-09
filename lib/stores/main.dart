import 'package:artic/adapters.dart';
import 'package:artic/http.dart';
import 'package:artic/routing.dart';
import 'package:flutter/material.dart';

class NavState extends ChangeNotifier {
  Destination _selectedDestination = Destination.artworks;
  String? _selectedArtworkId;
  String? _selectedArtistId;

  Destination get selectedDestination => _selectedDestination;
  String? get selectedArtworkId => _selectedArtworkId;
  String? get selectedArtistId => _selectedArtistId;

  set selectedDestination(Destination destination) {
    _selectedDestination = destination;
    notifyListeners();
  }

  set selectedArtworkId(String? id) {
    _selectedArtworkId = id;
    notifyListeners();
  }

  set selectedArtistId(String? id) {
    _selectedArtistId = id;
    notifyListeners();
  }
}

class MainStore extends ChangeNotifier {
  Locale? _currentLocale;
  ArticArtworkPayload? _artworksPayload;
  Exception? _artworksException;
  NavState _navState = NavState();

  /// We basically want to prevent payload to be settable from outside.
  Locale? get currentLocale => _currentLocale;
  ArticArtworkPayload? get artworksPayload => _artworksPayload;
  Exception? get artworksException => _artworksException;
  NavState get navState => _navState;

  /// This is actually what we want:
  /// setters that automatically invoke `notifyListeners()`

  set currentLocale(Locale? l) {
    _currentLocale = l;
    notifyListeners();
  }

  Future<void> fetch() async {
    print('fetching artworks');

    /// fetchArtworks already handles conversion
    /// to the right data types so we can just use it.
    try {
      _artworksPayload = await fetchArtworks();
    } on Error catch (t) {
      _artworksException = Exception(t.toString());
    } on Exception catch (d) {
      _artworksException = d;
    } catch (x) {
      _artworksException = Exception("${x.runtimeType}: ${x.toString()}");
    }

    /// "Hi all, new payload is here!"
    notifyListeners();
  }
}
