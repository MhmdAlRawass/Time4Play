import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:time4play/screens/bookings/upcoming_bookings.dart';
import 'package:time4play/screens/venues/venues.dart';
import 'package:time4play/screens/home/home.dart';
import 'package:time4play/screens/settings/settings.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:badges/src/badge.dart'
    as custom_badge; // Import the badges package with a prefix

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  void switchScreens(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void preloadAssetImage(BuildContext context) {
    precacheImage(AssetImage('lib/assets/images/home/4b-stadium.jpg'), context);
  }

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomeScreen(
        switchScreen: switchScreens,
      ),
      VenuesPage(
        switchScreen: switchScreens,
      ),
      UpcomingBookingsScreen(
        switchScreen: switchScreens,
      ),
      SettingsPage(
        switchScreen: switchScreens,
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      preloadAssetImage(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: _pages,
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _pageIndex,
        curve: Curves.linearToEaseOut,
        margin: EdgeInsets.symmetric(horizontal: 36, vertical: 8),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home_outlined),
            title: Text('Home'),
          ),
          SalomonBottomBarItem(
            icon: ImageIcon(
              AssetImage('lib/assets/icons/venue.png'),
              size: 24,
            ),
            title: Text('Venues'),
          ),
          SalomonBottomBarItem(
            icon: custom_badge.Badge(
              showBadge: true,
              badgeStyle: BadgeStyle(
                badgeColor: Theme.of(context).colorScheme.primary,
              ),
              badgeContent: Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
              position: BadgePosition.topEnd(top: -10, end: -10),
              child: ImageIcon(
                AssetImage('lib/assets/icons/playing.png'),
                size: 24,
              ),
            ),
            title: Text('Bookings'),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.settings_outlined),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
