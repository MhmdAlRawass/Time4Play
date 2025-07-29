import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoggingInScreen extends StatefulWidget {
  const LoggingInScreen({super.key});

  @override
  State<LoggingInScreen> createState() => _LoggingInScreenState();
}

class _LoggingInScreenState extends State<LoggingInScreen>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _animations = _controllers
        .map((controller) => Tween<Offset>(
              begin: const Offset(0, 0),
              end: const Offset(0, -0.1),
            ).animate(
              CurvedAnimation(
                parent: controller,
                curve: Curves.easeInOut,
              ),
            ))
        .toList();

    _startLoopingAnimations();
  }

  void _startLoopingAnimations() async {
    while (mounted) {
      for (int i = 0; i < _controllers.length; i++) {
        await _controllers[i].forward();
        await _controllers[i].reverse();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildDot(int index, bool isDarkMode) {
    return SlideTransition(
      position: _animations[index],
      child: Text(
        '.',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'lib/assets/animations/logging_in.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Signing In',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 6),
                _buildDot(0, isDarkMode),
                _buildDot(1, isDarkMode),
                _buildDot(2, isDarkMode),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Please wait while we signing in to app.',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
