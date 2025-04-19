import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CreatingProfileScreen extends StatefulWidget {
  const CreatingProfileScreen({super.key});

  @override
  State<CreatingProfileScreen> createState() => _CreatingProfileScreenState();
}

class _CreatingProfileScreenState extends State<CreatingProfileScreen>
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

  Widget _buildDot(int index) {
    return SlideTransition(
      position: _animations[index],
      child: const Text(
        '.',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'lib/assets/animations/creating_profile.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Creating your profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                _buildDot(0),
                _buildDot(1),
                _buildDot(2),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Please wait while we set up your profile.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
