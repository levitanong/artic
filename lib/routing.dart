import 'package:artic/stores/main_store.dart';
import 'package:artic/ui/artworks_destination.dart';
import 'package:artic/ui/root.dart';
import 'package:artic/ui/settings_destination.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Destination { artworks, artists, settings }

extension BottomBarItem on Destination {
  /// We use the tedious switch case because it helps us with linting
  /// when a new enum value is added to Destination.
  IconData get icon {
    switch (this) {
      case Destination.artworks:
        return Icons.portrait;
      case Destination.artists:
        return Icons.person;
      case Destination.settings:
        return Icons.settings;
    }
  }

  /// We use the tedious switch case because it helps us with linting
  /// when a new enum value is added to Destination.
  String? label(BuildContext context) {
    switch (this) {
      case Destination.artworks:
        return AppLocalizations.of(context)?.artworks ?? 'Artworks';
      case Destination.artists:
        return AppLocalizations.of(context)?.artists ?? 'Artists';
      case Destination.settings:
        return 'Settings';
    }
  }

  Widget get screen {
    switch (this) {
      case Destination.artworks:
        return ArtworksDestination();
      case Destination.artists:
        return Text('Artists');
      case Destination.settings:
        return SettingsDestination();
    }
  }
}

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

class SelectiveListener<S extends Listenable, T> extends ChangeNotifier {
  T? _cache;

  SelectiveListener({required this.store, required this.selector}) {
    // Automatically bind the listener to the store since we get the store anyway.
    store.addListener(() {
      _selectivelyListen();
    });
  }

  final S store;
  final T Function(S store) selector;

  void _selectivelyListen() {
    final selected = selector(store);
    if (selected != _cache) {
      _cache = selected;
      notifyListeners();
    }
    // if they're equal, don't do anything.
  }
}

class ArticRouterDelegate extends RouterDelegate<NavRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavRoute> {
  MainStore mainStore;
  // late because this depends on the mainStore being passed
  // into the constructor of SelectiveListener.
  // So we'll need to put this in the constructor body of ArticRouterDelegate later.
  late SelectiveListener selectiveListener;

  /// I'm actually not sure why this has to be overridden, but let's let that slide for now.
  final GlobalKey<NavigatorState> navigatorKey;

  /// This is the initializer list syntax that sets fields
  /// before the constructor body runs.
  ArticRouterDelegate(this.mainStore)
      : navigatorKey = GlobalKey<NavigatorState>() {
    // The actual constructor body
    // Now we define selectiveListener, because now we have access to mainStore.
    selectiveListener =
        SelectiveListener<MainStore, Tuple3<Destination, String?, String?>>(
            store: mainStore,
            selector: (MainStore store) {
              return Tuple3(store.selectedDestination, store.selectedArtworkId,
                  store.selectedArtistId);
            });
    // selectiveListener is itself a ChangeNotifier.
    // it's changenotifiers all the way down.
    selectiveListener.addListener(notifyListeners);
  }

  /// This is considered an optional override,
  /// but this is important to us to do things like
  /// make the address bar reflect our navigation state.
  @override
  NavRoute? get currentConfiguration {
    /// We'll go through all the possible destinations
    /// in navStore, then determine we're looking at a specific entity or not.
    switch (mainStore.selectedDestination) {
      case Destination.artworks:
        if (mainStore.selectedArtworkId != null) {
          /// ArtworkRoute is a subclass of NavRoute.
          return ArtworkRoute(id: mainStore.selectedArtworkId!);
        } else {
          return ArtworksRoute();
        }
      case Destination.artists:
        if (mainStore.selectedArtistId != null) {
          /// Again, ArtistRoute is a subclass of NavRoute
          return ArtistRoute(id: mainStore.selectedArtistId!);
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
    mainStore.selectedDestination = configuration.destination;

    /// I know, if else if else if is really tedious,
    /// but switching on the runtimeType doesn't implicitly cast
    /// so we're really trading one ugly for another.
    if (configuration is ArtworksRoute) {
      /// It's important to null this field because this is the only
      /// thing that makes Artworks and Artwork distinct from each other.
      mainStore.selectedArtworkId = null;
    } else if (configuration is ArtworkRoute) {
      mainStore.selectedArtworkId = configuration.id;
    } else if (configuration is ArtistsRoute) {
      mainStore.selectedArtistId = null;
    } else if (configuration is ArtistRoute) {
      mainStore.selectedArtistId = configuration.id;
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
