import 'package:artic/adapters.dart';
import 'package:artic/http.dart';
import 'package:flutter/material.dart';

class ArtworkDetailScreen extends StatefulWidget {
  // Parametrizing ArtworkDetailScreen to accept an ID.
  const ArtworkDetailScreen({required this.id});
  final String id;

  @override
  _ArtworkDetailScreenState createState() => _ArtworkDetailScreenState();
}

class _ArtworkDetailScreenState extends State<ArtworkDetailScreen> {
  // The future of art!
  late Future<ArticArtwork> artworkFuture;

  @override
  void initState() {
    // Remember that this is the State,
    // so we have access to the widget getter,
    // which is a reference to the actual StatefulWidget.
    artworkFuture = fetchArtwork(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder rebuilds when a future resolves
    return FutureBuilder<ArticArtwork>(
        future: artworkFuture,
        builder: (context, snapshot) {
          // When `fetchArtwork` throws.
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          // "loading"
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data?.title ?? 'Artwork'),
            ),
            body: Text(snapshot.data?.title ?? 'Artwork'),
          );
        });
  }
}
