import 'package:artic/adapters.dart';
import 'package:artic/routing.dart';
import 'package:artic/stores/artworks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtworksListScreen extends StatefulWidget {
  const ArtworksListScreen({Key? key}) : super(key: key);

  @override
  _ArtworksListScreenState createState() => _ArtworksListScreenState();
}

class _ArtworksListScreenState extends State<ArtworksListScreen> {
  // Instantiate the artworksStore
  final artworksStore = ArtworksStore();

  @override
  void initState() {
    // Since we're not using the Provider/Consumer pattern
    // nothing will happen unless we register a listener that
    // causes a rebuild. Here we register safeRefresh.
    artworksStore.addListener(safeRefresh);
    // trigger a fetch whenever state is initialized
    artworksStore.fetch();
    super.initState();
  }

  @override
  void dispose() {
    // To make sure we don't accumulate listeners,
    // Let's remove the listener before disposal.
    artworksStore.removeListener(safeRefresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We want the title to either show that it's loading,
    // or show the state of pagination.
    final paginationState = _paginationText(artworksStore.payload?.pagination);
    final title = "Artworks ($paginationState)";
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        // It's only at this point that NavStore is relevant,
        // so this is where we use the Consumer.
        // We should use Consumers as deep as possible.
        body: Consumer<NavStore>(
          builder: (context, navStore, child) {
            if (artworksStore.hasError && artworksStore.exception != null) {
              return Text(artworksStore.exception!.toString());
            }
            // null safety type promotion only happens to
            // vars defined in scope.
            final payload = artworksStore.payload;
            // Check null, return
            if (payload == null) {
              return CircularProgressIndicator();
            }
            return ListView.builder(
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
                        navStore.selectedArtworkId = artwork.id;
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        // We can eventually make this nicer,
                        // but this is enough for demonstration.
                        child: Text(artwork.title),
                      ),
                    ),
                  );
                });
          },
        ));
  }

  /// Represents pagination state in text.
  String _paginationText(ArticArtworkPagination? pagination) {
    if (pagination == null) {
      return 'loading';
    }
    return "${pagination.currentPage} of ${pagination.totalPages}";
  }

  /// Very simple. Checks if Widget is mounted,
  /// if so, setState on nothing. This doesn't change
  /// any var, but it still triggers a rebuild.
  void safeRefresh() {
    if (mounted) {
      setState(() {});
    }
  }
}
