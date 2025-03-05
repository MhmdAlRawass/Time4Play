// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// void main() {

//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//       .then((_) {
//     runApp(const MyApp());
//   });
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Time4Play',
//       debugShowCheckedModeBanner: false,
//       theme: darkTheme,
//       home: const MainScreen(),
//     );
//   }
// }

// final ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   useMaterial3: true,
//   primaryColor: const Color(0xFF0D47A1), // Deep dark blue
//   scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
//   cardColor: const Color(0xFF1E1E1E), // Dark grey card
//   appBarTheme: const AppBarTheme(
//     backgroundColor: Color(0xFF0D47A1),
//   ),
//   textTheme: const TextTheme(
//     headlineLarge: TextStyle(
//       color: Colors.white,
//       fontSize: 32,
//       fontWeight: FontWeight.bold,
//     ),
//     headlineSmall: TextStyle(
//       color: Colors.white,
//       fontSize: 20,
//       fontWeight: FontWeight.bold,
//     ),
//     bodyLarge: TextStyle(
//       color: Colors.white,
//       fontSize: 16,
//     ),
//     bodyMedium: TextStyle(
//       color: Colors.white70,
//       fontSize: 14,
//     ),
//   ),
//   colorScheme: ColorScheme.dark(
//     primary: const Color(0xFF0D47A1),
//     secondary: const Color(0xFF64FFDA),
//     surface: const Color(0xFF1E1E1E),
//     error: Colors.redAccent,
//     onPrimary: Colors.white,
//     onSecondary: Colors.black,
//     onSurface: Colors.white,
//     onError: Colors.white,
//   ),
// );

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen>
//     with SingleTickerProviderStateMixin {
//   // Pages: 0 = Home, 1 = Bookings, 2 = Settings.
//   int _selectedIndex = 0;

//   // Animation controller for the notch margin (curve effect under the FAB).
//   late AnimationController _notchController;
//   late Animation<double> _notchAnimation;
//   double _notchMargin = 6.0;

//   @override
//   void initState() {
//     super.initState();
//     _notchController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _notchAnimation = Tween<double>(begin: 6.0, end: 20.0).animate(
//       CurvedAnimation(parent: _notchController, curve: Curves.easeInOut),
//     )..addListener(() {
//         setState(() {
//           _notchMargin = _notchAnimation.value;
//         });
//       });
//   }

//   @override
//   void dispose() {
//     _notchController.dispose();
//     super.dispose();
//   }

//   // When the FAB is pressed, switch to the Bookings page and animate the notch.
//   void _onFABPressed() {
//     setState(() {
//       _selectedIndex = 1;
//       _notchController.forward();
//     });
//     if (_notchController.status == AnimationStatus.completed) {
//       _notchController.reverse();
//     } else {
//       _notchController.forward();
//     }
//   }

//   // Tapping on the left/right navigation icons changes pages.
//   void _onNavItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   // List of pages
//   final List<Widget> _pages = const [
//     // HomeScreen(),
//     // BookingsPage(),
//     // SettingsPage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Time4Play Dashboard"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               // Consider adding an animated notifications view or badge.
//             },
//           ),
//         ],
//       ),
//       // Use AnimatedSwitcher with IndexedStack for smooth page transitions.
//       body: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 500),
//         transitionBuilder: (child, animation) => FadeTransition(
//           opacity: animation,
//           child: child,
//         ),
//         child: IndexedStack(
//           key: ValueKey<int>(_selectedIndex),
//           index: _selectedIndex,
//           children: _pages,
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _onFABPressed,
//         child: const Icon(Icons.calendar_today),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: _notchMargin,
//         color: const Color(0xFF1E1E1E),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.home),
//               color: _selectedIndex == 0
//                   ? Theme.of(context).colorScheme.secondary
//                   : Colors.white70,
//               onPressed: () => _onNavItemTapped(0),
//             ),
//             // Leave space in the middle for the FAB.
//             const SizedBox(width: 48),
//             IconButton(
//               icon: const Icon(Icons.settings),
//               color: _selectedIndex == 2
//                   ? Theme.of(context).colorScheme.secondary
//                   : Colors.white70,
//               onPressed: () => _onNavItemTapped(2),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
