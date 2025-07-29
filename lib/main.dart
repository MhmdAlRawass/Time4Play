import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time4play/entry_point.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:time4play/services/theme_service.dart';

final ThemeData darkTheme = ThemeData(
  fontFamily: 'WinkyRough',
  brightness: Brightness.dark,
  useMaterial3: true,
  primaryColor: const Color(0xFF0D47A1),
  scaffoldBackgroundColor: const Color(0xFF0F172A),
  cardColor: const Color(0xFF1E1E1E),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0F172A),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: Colors.white,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Color.fromRGBO(255, 255, 255, 0.702),
      fontSize: 14,
    ),
  ),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF0D47A1),
    secondary: Color(0xFF64FFDA),
    surface: Color(0xFF1E1E1E),
    error: Colors.redAccent,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onError: Colors.white,
  ),
);

final ThemeData lightTheme = ThemeData(
  fontFamily: 'WinkyRough',
  brightness: Brightness.light,
  useMaterial3: true,
  primaryColor: const Color(0xFF2196F3),
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),
  cardColor: const Color(0xFFFFFFFF),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFAFAFA),
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: Colors.black,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0.6),
      fontSize: 14,
    ),
  ),
  colorScheme: ColorScheme.light(
    primary: Color(0xFF0D47A1),
    secondary: Color.fromARGB(201, 33, 149, 243),
    surface: Color(0xFFFFFFFF),
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onError: Colors.white,
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.currentPlatform,
        );
  }
  OneSignal.Debug.setLogLevel(OSLogLevel.none);

  OneSignal.initialize(
    '3447e44a-de0a-4dd8-a4bd-19b8bd74ebb0',
  );

  // OneSignal.Notifications.requestPermission(false);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ProviderScope(
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    return MaterialApp(
      title: 'Time4Play',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: const EntryPoint(),
    );
  }
}
