import 'package:artic/routing.dart';
import 'package:artic/stores/main_store.dart';
import 'package:artic/ui/artwork_detail_screen.dart';
import 'package:artic/ui/artworks_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtworksDestination extends StatefulWidget {
  const ArtworksDestination({Key? key}) : super(key: key);

  @override
  _ArtworksDestinationState createState() => _ArtworksDestinationState();
}

class _ArtworksDestinationState extends State<ArtworksDestination> {
  // For the navigator
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final mainStore = Provider.of<MainStore>(context, listen: false);
    // We need access to navStore so we know
    // whether or not an individual artwork is selected.
    return Selector<MainStore, String?>(
      selector: (context, mainStore) {
        return mainStore.navState.selectedArtworkId;
      },
      builder: (buildContext, selectedArtworkId, artworksListScreen) {
        // This is the second navigator we've written.
        // Navigators are actually independent from routeDelegate, etc...
        return Navigator(
          key: navigatorKey,
          pages: [
            // List screen. We'll fill it up later.
            MaterialPage(child: artworksListScreen!),

            // Detail screen. We'll fill it up later.
            // Note that the only thing controlling
            // whether or not it's visible is the value of selectedArtworkId.
            if (selectedArtworkId != null)
              // Notice: We're passing the ID to the constructor.
              MaterialPage(child: ArtworkDetailScreen(id: selectedArtworkId))
          ],

          // This onPopPage method is actually relevant
          // Because it actually handles the transition from
          // detail view to list view.
          onPopPage: (route, result) {
            // Because selectedArtworkId is the only thing
            // dictating whether or not the detail view shows,
            // it naturally follows that we should set it to null
            // when we pop.
            mainStore.navState.selectedArtworkId = null;
            return route.didPop(result);
          },
        );
      },
      child: ArtworksListScreen(),
    );
  }
}
