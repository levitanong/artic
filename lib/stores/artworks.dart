import 'dart:async';

import 'package:artic/adapters.dart';
import 'package:artic/http.dart';
import 'package:flutter/foundation.dart';

class ArtworksStore extends ChangeNotifier {
  ArticArtworkPayload? _payload;
  bool _hasError = false;
  Exception? _exception;

  /// We basically want to prevent payload to be settable from outside.
  ArticArtworkPayload? get payload => _payload;
  bool get hasError => _hasError;
  Exception? get exception => _exception;

  Future<void> fetch() async {
    /// fetchArtworks already handles conversion
    /// to the right data types so we can just use it.
    try {
      _payload = await fetchArtworks();
    } on Exception catch (d) {
      _hasError = true;
      _exception = d;
    }

    /// "Hi all, new payload is here!"
    notifyListeners();
  }
}
