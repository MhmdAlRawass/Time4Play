import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time4play/models/sport.dart';
import 'package:time4play/screens/booking.dart';
import 'package:time4play/widgets/gradient_border.dart';

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
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        child: GradientBorderContainer(
                          rightColor: Colors.redAccent,
                          leftColor: const Color.fromARGB(255, 33, 40, 243),
                          borderWidth: 2,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'lib/assets/basketball.jpeg'),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 12,
                                    child: SizedBox(
                                      width: 200,
                                      child: Text(
                                        sport.name,
                                        style: GoogleFonts.inter(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500
                                            // fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 12,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Starting from',
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '\$ ${sport.price.toStringAsFixed(2)}',
                                              style: GoogleFonts.inter(
                                                fontSize: 24,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              ' / Hr',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      onPressed: () {},
                                      splashColor:
                                          Theme.of(context).colorScheme.primary,
                                      focusColor:
                                          Theme.of(context).colorScheme.primary,
                                      icon: Icon(Icons.star_border),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.location_on_outlined),
                                  ),
                                  Text(
                                    sport.description,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
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
