import 'package:flutter/material.dart';
/// BookingsPage: Displays a list of bookings with animated fade-in effect.
/// Each booking is shown in a card with a "View" button.
class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage>
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

  // Sample booking data
  final List<Map<String, String>> bookings = const [
    {"title": "Tennis Court", "date": "Today, 4 PM", "location": "Court 1"},
    {
      "title": "Football Field",
      "date": "Tomorrow, 3 PM",
      "location": "Field A"
    },
    {
      "title": "Basketball Court",
      "date": "Friday, 6 PM",
      "location": "Court 2"
    },
    {
      "title": "Swimming Pool",
      "date": "Next Monday, 10 AM",
      "location": "Pool X"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FadeTransition(
        opacity: _bookingsFadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Bookings",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Card(
                      color: Theme.of(context).cardColor,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          booking["title"]!,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        subtitle: Text(
                          "${booking["date"]!} - ${booking["location"]!}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            // Consider using a Hero widget for detailed view transitions.
                          },
                          child: Text(
                            "View",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
