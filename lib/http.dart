import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'adapters.dart';

Future<ArticArtworkPayload> fetchArtworks() async {
  final url = Uri.parse(
      'https://api.artic.edu/api/v1/artworks?page=1&limit=10&fields=id,api_link,title,thumbnail,artist_display,date_display,medium_display,dimensions,main_reference_number');
  try {
    final http.Response response = await http
        .get(url)
        .timeout(Duration(milliseconds: 5000), onTimeout: () {
      throw TimeoutException("http request timed out");
    });
    switch (response.statusCode) {
      case 200:
        final body = jsonDecode(response.body);
        final articPayload = ArticArtworkPayload.fromJson(body);
        return articPayload;
      default:
        throw response;
    }
  } catch (e) {
    throw e;
  }
}

Future<ArticArtwork> fetchArtwork(String id) async {
  final url = Uri.parse("https://api.artic.edu/api/v1/artworks/$id");
  final response = await http.get(url);

  // Using switch-case because we might want to handle other statusCodes differently
  switch (response.statusCode) {
    case 200:
      final body = jsonDecode(response.body);
      final articArtwork = ArticArtwork.fromJson(body['data']);
      return articArtwork;
    case 404:
      throw "Not found";
    default:
      throw "Unknown error";
  }
}
