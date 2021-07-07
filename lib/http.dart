import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'adapters.dart';

Future<ArticArtworkPayload> fetchArtworks() async {
  final fields =
      'id,api_link,title,thumbnail,artist_display,date_display,medium_display,dimensions,main_reference_number';
  final url = Uri(
      scheme: 'https',
      host: 'api.artic.edu',
      path: '/api/v1/artworks',
      queryParameters: {'page': '1', 'limit': '10', 'fields': fields});
  try {
    final Response response = await get(url);
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
  final Response response = await get(url);

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
