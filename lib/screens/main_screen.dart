import 'package:badges/badges.dart' as custom_badge;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:time4play/providers/user_bookings_provider.dart';

import 'package:time4play/screens/bookings/upcoming_bookings.dart';
import 'package:time4play/screens/login/login_screen.dart';
import 'package:time4play/screens/sign_up_and_steps/create_profile.dart';
import 'package:time4play/screens/venues/venues.dart';
import 'package:time4play/screens/home/home.dart';
import 'package:time4play/screens/settings/settings.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _pageIndex = 0;
  String? selectedSport;
  final auth = FirebaseAuth.instance;

  final List<Widget?> _pages =
      List.filled(4, null); // 4 pages, all null initially

  int bookingBadgeCount = 0;

  void switchScreens(int page, {String? selectedSport}) {
    setState(() {
      _pageIndex = page;
      this.selectedSport = selectedSport;
    });
  }

  void preloadAssetImage(BuildContext context) {
    precacheImage(
      const AssetImage('lib/assets/images/home/4b-stadium.jpg'),
      context,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      preloadAssetImage(context);
      _checkIfUserIsLoggedIn();
    });
  }

  void _checkIfUserIsLoggedIn() async {
    final user = auth.currentUser;

    final firestore = FirebaseFirestore.instance;

    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    try {
      final userData =
          await firestore.collection('customer').doc(user.uid).get();

      if (!userData.exists) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CreateProfile(
              emailController: TextEditingController(text: user.email),
              isGoogleSignIn: true,
              userId: user.uid,
            ),
          ),
        );
      }
    } catch (e) {
      print('Home Creating Profile Error: $e');
    }
  }

  Widget _getOrCreatePage(int index) {
    if (_pages[index] != null) return _pages[index]!;

    switch (index) {
      case 0:
        _pages[0] = HomeScreen(switchScreen: switchScreens);
        break;
      case 1:
        _pages[1] = VenuesPage(
          switchScreen: switchScreens,
          selectedSport: selectedSport,
        );
        break;
      case 2:
        _pages[2] = UpcomingBookingsScreen(switchScreen: switchScreens);
        break;
      case 3:
        _pages[3] = SettingsPage(switchScreen: switchScreens);
        break;
    }

    return _pages[index]!;
  }

  @override
  Widget build(BuildContext context) {
    // Build pages only when needed
    for (int i = 0; i < _pages.length; i++) {
      if (_pages[i] == null && i == _pageIndex) {
        _getOrCreatePage(i);
      }
    }

    final bookingsAsync = ref.watch(userBookingsProvider);
    if (bookingsAsync.hasValue) {
      final upComing = bookingsAsync.value!
          .where(
        (booking) => booking.startTime.isAfter(
          DateTime.now(),
        ),
      )
          .where((booking) {
        return booking.customerId == auth.currentUser!.uid;
      }).toList();
      setState(() {
        bookingBadgeCount = upComing.length;
      });
    }
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: List.generate(
          _pages.length,
          (i) => _pages[i] ?? const SizedBox(),
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _pageIndex,
        curve: Curves.linearToEaseOut,
        margin: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_outlined),
            title: const Text('Home'),
          ),
          SalomonBottomBarItem(
            icon: const ImageIcon(
              AssetImage('lib/assets/icons/venue.png'),
              size: 24,
            ),
            title: const Text('Venues'),
          ),
          SalomonBottomBarItem(
            icon: custom_badge.Badge(
              showBadge: bookingBadgeCount > 0,
              badgeStyle: custom_badge.BadgeStyle(
                badgeColor: Theme.of(context).colorScheme.primary,
              ),
              badgeContent: Text(
                '$bookingBadgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
              position: custom_badge.BadgePosition.topEnd(top: -10, end: -10),
              child: const ImageIcon(
                AssetImage('lib/assets/icons/playing.png'),
                size: 24,
              ),
            ),
            title: const Text('Bookings'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
