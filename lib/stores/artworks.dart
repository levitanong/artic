import 'package:artic/adapters.dart';
import 'package:artic/http.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class ArtworksStore extends ChangeNotifier {
  ArticArtworkPayload? _payload;
  bool _hasError = false;
  Response? _debugResponse;

  /// We basically want to prevent payload to be settable from outside.
  ArticArtworkPayload? get payload => _payload;
  bool get hasError => _hasError;
  Response? get debugResponse => _debugResponse;

  void fetch() async {
    /// fetchArtworks already handles conversion
    /// to the right data types so we can just use it.
    try {
      _payload = await fetchArtworks();
    } on Response catch (r) {
      _hasError = true;
      _debugResponse = r;
    }

    /// "Hi all, new payload is here!"
    notifyListeners();
  }
}
