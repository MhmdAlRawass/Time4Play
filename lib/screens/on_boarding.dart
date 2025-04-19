import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:time4play/screens/login/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Onboarding content for Time4Play
  final List<Map<String, String>> _onboardingPages = [
    {
      'title': 'Discover Fun Venues',
      'description':
          'Explore the best venues in Lebanon for sports, events, and entertainment. Book your next adventure with Time4Play!',
      'lottie': 'lib/assets/animations/fun_venues.json',
    },
    {
      'title': 'Book in Seconds',
      'description':
          'Reserve your favorite venues in just a few taps. Instant confirmation and hassle-free booking.',
      'lottie': 'lib/assets/animations/quick_booking.json',
    },
    {
      'title': 'For Everyone',
      'description':
          'Whether you’re a business listing your venue or a user looking to play, Time4Play connects everyone seamlessly.',
      'lottie': 'lib/assets/animations/team.json',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Color(0xFF0D47A1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button (Top Right)
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    _currentPage == _onboardingPages.length - 1 ? '' : 'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),

              // Page View
              Expanded(
                flex: 4,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardingPages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) => OnboardingPage(
                    title: _onboardingPages[index]['title']!,
                    description: _onboardingPages[index]['description']!,
                    lottiePath: _onboardingPages[index]['lottie']!,
                  ),
                ),
              ),

              // Page Indicator
              _buildPageIndicator(),

              // Navigation Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      if (_currentPage == _onboardingPages.length - 1) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (ctx) => LoginScreen(),
                          ),
                        );
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      _currentPage == _onboardingPages.length - 1
                          ? 'Let’s Play!'
                          : 'Next',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Page Indicator
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _onboardingPages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Colors.blueAccent
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String lottiePath;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.lottiePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Lottie Animation
            Expanded(
            flex: 3,
            child: Lottie.asset(
              lottiePath,
              fit: BoxFit.contain,
              animate: true,
              repeat: true,
              reverse: false,
            ),
          ),

          // Text Content
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
