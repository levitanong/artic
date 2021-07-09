import 'package:artic/stores/main_store.dart';
import 'package:artic/ui/root.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Destination { artworks, artists, settings }

abstract class NavRoute {
  /// Default is Destination.artworks.
  final Destination destination = Destination.artworks;
}

class ArtworksRoute extends NavRoute {
  final Destination destination = Destination.artworks;
}

class ArtworkRoute extends NavRoute {
  final Destination destination = Destination.artworks;
  final String id;
  ArtworkRoute({required this.id});
}

class ArtistsRoute extends NavRoute {
  final Destination destination = Destination.artists;
}

class ArtistRoute extends NavRoute {
  final Destination destination = Destination.artists;
  final String id;
  ArtistRoute({required this.id});
}

class SettingsRoute extends NavRoute {
  final Destination destination = Destination.settings;
}

class NotFoundRoute extends NavRoute {}

class NavStore extends ChangeNotifier {
  Destination _selectedDestination = Destination.artworks;
  String? _selectedArtworkId;
  String? _selectedArtistId;

  /// Define getters only as a matter of course,
  /// because we want custom setters.
  Destination get selectedDestination => _selectedDestination;
  String? get selectedArtworkId => _selectedArtworkId;
  String? get selectedArtistId => _selectedArtistId;

  /// This is actually what we want:
  /// setters that automatically invoke `notifyListeners()`
  set selectedDestination(Destination destination) {
    _selectedDestination = destination;
    notifyListeners();
  }

  set selectedArtworkId(String? id) {
    _selectedArtworkId = id;
    notifyListeners();
  }

  set selectedArtistId(String? id) {
    _selectedArtistId = id;
    notifyListeners();
  }
}

class ArticRouterDelegate extends RouterDelegate<NavRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavRoute> {
  /// The NavStore, a.k.a. navigation state.
  MainStore mainStore;

  /// I'm actually not sure why this has to be overridden, but let's let that slide for now.
  final GlobalKey<NavigatorState> navigatorKey;

  /// This is the initializer list syntax that sets fields
  /// before the constructor body runs.
  ArticRouterDelegate(this.mainStore)
      : navigatorKey = GlobalKey<NavigatorState>() {
    /// The aforementioned constructor body.
    /// Both NavStore and ArticRouterDelegate extend ChangeNotifier,
    /// and this basically makes it so that any change in navStore
    /// causes ArticRouterDelegate to also notifyListeners.
    mainStore.navState.addListener(notifyListeners);
  }

  /// This is considered an optional override,
  /// but this is important to us to do things like
  /// make the address bar reflect our navigation state.
  @override
  NavRoute? get currentConfiguration {
    /// We'll go through all the possible destinations
    /// in navStore, then determine we're looking at a specific entity or not.
    switch (mainStore.navState.selectedDestination) {
      case Destination.artworks:
        if (mainStore.navState.selectedArtworkId != null) {
          /// ArtworkRoute is a subclass of NavRoute.
          return ArtworkRoute(id: mainStore.navState.selectedArtworkId!);
        } else {
          return ArtworksRoute();
        }
      case Destination.artists:
        if (mainStore.navState.selectedArtistId != null) {
          /// Again, ArtistRoute is a subclass of NavRoute
          return ArtistRoute(id: mainStore.navState.selectedArtistId!);
        } else {
          return ArtistsRoute();
        }
      case Destination.settings:
        return SettingsRoute();
    }
  }

  @override
  Future<void> setNewRoutePath(NavRoute configuration) async {
    /// Because we've said all NavRoutes have destination,
    /// we can immediately set this value.
    mainStore.navState.selectedDestination = configuration.destination;

    /// I know, if else if else if is really tedious,
    /// but switching on the runtimeType doesn't implicitly cast
    /// so we're really trading one ugly for another.
    if (configuration is ArtworksRoute) {
      /// It's important to null this field because this is the only
      /// thing that makes Artworks and Artwork distinct from each other.
      mainStore.navState.selectedArtworkId = null;
    } else if (configuration is ArtworkRoute) {
      mainStore.navState.selectedArtworkId = configuration.id;
    } else if (configuration is ArtistsRoute) {
      mainStore.navState.selectedArtistId = null;
    } else if (configuration is ArtistRoute) {
      mainStore.navState.selectedArtistId = configuration.id;
    } else if (configuration is SettingsRoute) {
      /// Actually there's nothing SettingsRoute specific for now.
      /// But we'll keep it here just in case.
    }
  }

  @override
  Widget build(BuildContext context) {
    /// We're going to use navStore a lot,
    /// so use ChangeNotifierProvider, passing in navStore.
    return Navigator(
      /// We initialized this earlier
      key: navigatorKey,

      /// Yes, just one page. `pages` needs to just be a list of `Page`s.
      /// `MaterialPage` is a subclass of `Page`.
      /// We're starting small by just making the child a Text Widget.
      pages: [MaterialPage(child: Root())],

      /// This is actually entirely vestigial because
      /// we're never going to pop here.
      /// Our stack can only be one level deep.
      /// We're keeping this here just in case we need it.
      /// It does no real harm.
      onPopPage: (route, result) => route.didPop(result),
    );
  }
}

class ArticRouteInformationParser extends RouteInformationParser<NavRoute> {
  /// There should be a more elegant way to do this,
  /// but parsing URLs is inherently messy,
  /// and people make libraries for this sort of thing.
  /// For now this will do.
  /// The implementation is inelegant, but easily understandable.
  @override
  Future<NavRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    if (routeInformation.location == null) {
      return NotFoundRoute();
    } else {
      final uri = Uri.parse(routeInformation.location!);
      final String? topLevel =
          uri.pathSegments.length >= 1 ? uri.pathSegments[0] : null;
      final String? id =
          uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
      switch (topLevel) {
        case "artworks":
          return (id != null) ? ArtworkRoute(id: id) : ArtworksRoute();
        case "artists":
          return (id != null) ? ArtistRoute(id: id) : ArtistsRoute();
        case "settings":
          return SettingsRoute();
        default:
          return NotFoundRoute();
      }
    }
  }

  /// I hate this repetition. I wish this were clojure.
  /// This is pretty straightforward though.
  /// We're just mapping NavRoute to URLs.
  @override
  RouteInformation? restoreRouteInformation(NavRoute configuration) {
    if (configuration is ArtworksRoute) {
      return RouteInformation(location: "/artworks");
    } else if (configuration is ArtworkRoute) {
      return RouteInformation(location: "/artworks/${configuration.id}");
    } else if (configuration is ArtistsRoute) {
      return RouteInformation(location: "/artists");
    } else if (configuration is ArtistRoute) {
      return RouteInformation(location: "/artists/${configuration.id}");
    } else if (configuration is SettingsRoute) {
      return RouteInformation(location: "/settings");
    } else {
      return null;
    }
  }
}
