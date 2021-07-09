import 'package:artic/adapters.dart';
import 'package:artic/stores/main_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ArtworksListScreen extends StatefulWidget {
  const ArtworksListScreen({Key? key}) : super(key: key);

  @override
  _ArtworksListScreenState createState() => _ArtworksListScreenState();
}

class _ArtworksListScreenState extends State<ArtworksListScreen> {
  @override
  void initState() {
    // trigger a fetch whenever state is initialized
    final mainStore = Provider.of<MainStore>(context, listen: false);
    mainStore.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // We want the title to either show that it's loading,
    // or show the state of pagination.
    final mainStore = Provider.of<MainStore>(context, listen: false);
    return Selector<MainStore, Tuple2<ArticArtworkPayload?, Exception?>>(
      selector: (context, mainStore) {
        return Tuple2(mainStore.artworksPayload, mainStore.artworksException);
      },
      builder: (context, tuple, child) {
        final payload = tuple.item1;
        final exception = tuple.item2;
        if (payload == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading'),
            ),
            body: CircularProgressIndicator(),
          );
        }
        if (exception != null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Text(exception.toString()),
          );
        }
        final paginationState = _paginationText(payload.pagination);
        final title = "Artworks ($paginationState)";
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: ListView.builder(
              // Now we don't have to bang the payload var.
              itemCount: payload.artworks.length,
              itemBuilder: (buildContext, index) {
                // This is the corresponding artwork in the list of artworks
                final artwork = payload.artworks[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      // Obvious what this does.
                      // The important thing is we're using navStore.
                      mainStore.navState.selectedArtworkId = artwork.id;
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      // We can eventually make this nicer,
                      // but this is enough for demonstration.
                      child: Text(artwork.title),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  /// Represents pagination state in text.
  String _paginationText(ArticArtworkPagination? pagination) {
    if (pagination == null) {
      return 'loading';
    }
    return "${pagination.currentPage} of ${pagination.totalPages}";
  }
}
