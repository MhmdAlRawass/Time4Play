import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time4play/models/sport.dart';
import 'package:time4play/screens/sports.dart';
import 'package:time4play/widgets/gradient_border.dart';

class VenuesPage extends StatefulWidget {
  const VenuesPage({super.key});

  @override
  State<VenuesPage> createState() => _VenuesPageState();
}

class _VenuesPageState extends State<VenuesPage>
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

  final List<Map<String, String>> venues = const [
    {"title": "4b Sporting Club", "location": "Koramangala, Bangalore"},
    {"title": "Play Arena", "location": "Sarjapur Road, Bangalore"},
    {"title": "Decathlon Sports", "location": "Bannerghatta Road, Bangalore"},
    {"title": "XLR8 Indoor Sports", "location": "Whitefield, Bangalore"},
  ];

  final sportsList = [
    Sport(name: 'Football', price: 22, description: 'Football Arena in 4b'),
    Sport(
        name: 'Basketball',
        price: 21.33,
        description: 'Basketball Arena in 4b'),
    Sport(name: 'Padel', price: 15, description: 'Padel Arena in 4b'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Venues'),
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
                  for (var venue in venues)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SportsPage(
                              sportsList: sportsList,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        child: GradientBorderContainer(
                          leftColor: Colors.redAccent,
                          rightColor: const Color.fromARGB(255, 33, 40, 243),
                          borderWidth: 2,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    // margin: const EdgeInsets.symmetric(vertical: 12),
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
                                        '${venue['title']}',
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
                                    '${venue['location']}',
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
