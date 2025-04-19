import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time4play/screens/main_screen.dart';
import 'package:time4play/screens/on_boarding.dart';

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context, snapshot) {
        // Checking loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If the user is logged in, go to main screen
        if (snapshot.hasData) {
          return const MainScreen();
        }

        // If not logged in, go to login screen
        return const OnboardingScreen();
      },
    );
  }
}
