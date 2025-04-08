import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time4play/providers/country_provider.dart';
import 'package:time4play/screens/on_boarding.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  primaryColor: const Color(0xFF0D47A1),
  // scaffoldBackgroundColor: const Color(0xFF121212),
  // scaffoldBackgroundColor: const Color(0xFF031024),
  scaffoldBackgroundColor: const Color(0xFF0F172A),
  cardColor: const Color(0xFF1E1E1E),
  appBarTheme: const AppBarTheme(
    // backgroundColor: Color(0xFF0D47A1),
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
      color: Colors.white70,
      fontSize: 14,
    ),
  ),
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFF0D47A1),
    secondary: const Color(0xFF64FFDA),
    surface: const Color(0xFF1E1E1E),
    error: Colors.redAccent,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onError: Colors.white,
  ),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MultiProvider(
        providers: providers,
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time4Play',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: const OnboardingScreen(),
    );
  }
}

final providers = [
  ChangeNotifierProvider(create: (context) => CountryProvider()),
];
