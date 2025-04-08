import 'package:flutter/material.dart';
import 'package:time4play/models/sport.dart';
import 'package:time4play/screens/venues/booking.dart';
import 'package:time4play/widgets/sports/sport_card.dart';

class SportsPage extends StatefulWidget {
  const SportsPage({
    super.key,
    required this.sportsList,
  });

  final List<Sport> sportsList;

  @override
  State<SportsPage> createState() => _SportsPageState();
}

class _SportsPageState extends State<SportsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _bookingsController;
  late Animation<double> _bookingsFadeAnimation;

  @override
  void initState() {
    super.initState();
    _bookingsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bookingsFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bookingsController, curve: Curves.easeIn),
    );
    _bookingsController.forward();
  }

  @override
  void dispose() {
    _bookingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Sports'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _bookingsFadeAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var sport in widget.sportsList)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BookingPage(),
                          ),
                        );
                      },
                      child: SportCard(
                        name: sport.name,
                        price: sport.price,
                        description: sport.description,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
