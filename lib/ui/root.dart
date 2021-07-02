import 'package:artic/routing.dart';
import 'package:artic/ui/artworks_destination.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  /// The following two maps are inelegant because they're separate
  /// But the only way to preserve the types is to make a NavBarData class
  /// and that's a different kind of ugly.
  /// For now, this ugly is simpler.
  static const destinationToNavBarIcons = {
    Destination.artworks: Icons.portrait,
    Destination.artists: Icons.person,
    Destination.settings: Icons.settings
  };
  static const destinationToNavBarLabels = {
    Destination.artworks: 'Artworks',
    Destination.artists: 'Artists',
    Destination.settings: 'Settings'
  };
  @override
  Widget build(BuildContext context) {
    /// This is how we grab navStore from Widget descendant of
    /// ChangeNotifierProvider.
    return Consumer<NavStore>(builder: (context, navStore, child) {
      /// These Text widgets will be replaced with the appropriate Widgets.
      final destinationWidgets = [
        ArtworksDestination(),
        Text('Artists'),
        Text('Settings'),
      ];

      /// selectedDestination is an enum of type Destination,
      /// but we can turn this into an int via the .index getter.
      final selectedDestinationIndex = navStore.selectedDestination.index;
      return Scaffold(
        /// Normally one would also specify an appbar here,
        /// but there's a better place to place an appbar.
        /// Right now, body just shows whatever destination is selected.
        body: destinationWidgets[selectedDestinationIndex],

        /// Setting up the bottom bar.
        bottomNavigationBar: BottomNavigationBar(
          /// Given that we already have the Destination enum,
          /// We simply iterate over the values, and access the maps we made
          /// To build the BottomNavigationBarItems.
          items: Destination.values.map<BottomNavigationBarItem>((destination) {
            return BottomNavigationBarItem(
                icon: Icon(destinationToNavBarIcons[destination]),
                label: destinationToNavBarLabels[destination]);
          }).toList(),

          /// Pretty obvious what this is.
          currentIndex: selectedDestinationIndex,

          /// Handler for tapping on a bottom nav bar item.
          onTap: (itemIndex) {
            /// having the navStore present is handy!
            /// the .values getter gives us the list of the entire enum
            /// in the order they were defined.
            /// This corresponds to how we arranged the bottom bar items.
            /// The way we implemented `items` though,
            /// we never have to worry about order.
            /// We're also using Destination.values, so they'll always match.
            navStore.selectedDestination = Destination.values[itemIndex];
          },
        ),
      );
    });
  }
}
