import 'package:flutter/material.dart';
import 'package:time4play/screens/venues.dart';
import 'package:time4play/screens/home.dart';
import 'package:time4play/screens/settings.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  final _pages = <Widget>[
    HomeScreen(),
    VenuesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // ),
      // drawer: Drawer(),
      body: _pages[_pageIndex],
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
            icon: Icon(Icons.play_arrow),
            title: Text('Book'),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person_outline),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}
