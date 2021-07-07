import 'dart:async';

import 'package:artic/adapters.dart';
import 'package:artic/http.dart';
import 'package:flutter/foundation.dart';

class ArtworksStore extends ChangeNotifier {
  ArticArtworkPayload? _payload;
  Exception? _exception;

  /// We basically want to prevent payload to be settable from outside.
  ArticArtworkPayload? get payload => _payload;
  Exception? get exception => _exception;

  Future<void> fetch() async {
    /// fetchArtworks already handles conversion
    /// to the right data types so we can just use it.
    try {
      _payload = await fetchArtworks();
    } on Error catch (t) {
      _exception = Exception(t.toString());
    }
    on Exception catch (d) {
      _exception = d;
    } catch (x)  {
      _exception = Exception("${x.runtimeType}: ${x.toString()}");
    }

    /// "Hi all, new payload is here!"
    notifyListeners();
  }
}
