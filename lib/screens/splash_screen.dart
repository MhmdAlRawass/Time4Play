import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() async {
    super.initState();
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'lib/assets/animations/sports.json',
        width: 200,
        height: 200,
        fit: BoxFit.fill,
        repeat: true,
        reverse: false,
        animate: true,
      ),
    );
  }
}
