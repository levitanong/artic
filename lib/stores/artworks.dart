import 'package:artic/adapters.dart';
import 'package:artic/http.dart';
import 'package:flutter/foundation.dart';

class ArtworksStore extends ChangeNotifier {
  ArticArtworkPayload? _payload;

  /// We basically want to prevent payload to be settable from outside.
  ArticArtworkPayload? get payload => _payload;

  void fetch() async {
    /// fetchArtworks already handles conversion
    /// to the right data types so we can just use it.
    _payload = await fetchArtworks();

    /// "Hi all, new payload is here!"
    notifyListeners();
  }
}
