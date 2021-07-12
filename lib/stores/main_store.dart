import 'package:artic/adapters.dart';
import 'package:artic/http.dart';
import 'package:artic/routing.dart';
import 'package:flutter/material.dart';

class MainStore extends ChangeNotifier {
  Locale? _currentLocale;
  ArticArtworkPayload? _artworksPayload;
  Exception? _artworksException;

  Destination _selectedDestination = Destination.artworks;
  String? _selectedArtworkId;
  String? _selectedArtistId;

  // We basically want to prevent payload to be settable from outside.

  Locale? get currentLocale => _currentLocale;
  ArticArtworkPayload? get artworksPayload => _artworksPayload;
  Exception? get artworksException => _artworksException;

  Destination get selectedDestination => _selectedDestination;
  String? get selectedArtworkId => _selectedArtworkId;
  String? get selectedArtistId => _selectedArtistId;

  // Setters

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

  set currentLocale(Locale? l) {
    _currentLocale = l;
    notifyListeners();
  }

  // Imperative methods

  Future<void> fetch() async {
    // fetchArtworks already handles conversion
    // to the right data types so we can just use it.
    try {
      _artworksPayload = await fetchArtworks();
    } on Error catch (t) {
      _artworksException = Exception(t.toString());
    } on Exception catch (d) {
      _artworksException = d;
    } catch (x) {
      _artworksException = Exception("${x.runtimeType}: ${x.toString()}");
    }

    // "Hi all, new payload is here!"
    notifyListeners();
  }
}
