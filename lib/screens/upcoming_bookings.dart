import 'dart:io';
import 'package:flutter/material.dart';
import 'package:time4play/screens/booking_info.dart';
import 'package:time4play/widgets/upcoming_bookings/booking_card.dart';

class UpcomingBookingsScreen extends StatefulWidget {
  const UpcomingBookingsScreen({
    super.key,
    required this.switchScreen,
  });

  final void Function(int) switchScreen;

  @override
  State<UpcomingBookingsScreen> createState() => _UpcomingBookingsScreenState();
}

class _UpcomingBookingsScreenState extends State<UpcomingBookingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _settingsController;
  late Animation<double> _settingsFadeAnimation;
  late TabController _tabController;
  int _currentIndex = 0; // Keeps track of the active tab

  @override
  void initState() {
    super.initState();
    _settingsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _settingsFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _settingsController, curve: Curves.easeIn),
    );
    _settingsController.forward();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _settingsController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, widget.switchScreen),
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).colorScheme.primary,
              dividerColor: Colors.transparent,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              tabs: [
                Tab(text: "Upcoming Matches"),
                Tab(text: "Previous Matches"),
              ],
            ),
            Expanded(
              child: FadeTransition(
                opacity: _settingsFadeAnimation,
                child: IndexedStack(
                  index: _currentIndex,
                  children: [
                    _buildUpcomingBookings(),
                    _buildPreviousBookings(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingBookings() {
    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingInfoPage(
                  courtName: "4b Sporting Club",
                  date: "Today • 4:00 PM",
                  duration: "2 hours",
                  price: "\$45",
                  image: 'lib/assets/images/venues/football.jpg',
                  isUpcoming: true, // Upcoming booking
                ),
              ),
            );
          },
          child: BookingCard(
            courtName: "4b Sporting Club",
            date: "Today • 4:00 PM",
            duration: "2 hours",
            price: "\$45",
            image: 'lib/assets/images/venues/football.jpg',
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingInfoPage(
                  courtName: "StreetBall Club",
                  date: "Tomorrow • 3:30 PM",
                  duration: "1.5 hours",
                  price: "\$30",
                  image: 'lib/assets/images/venues/basketball.jpeg',
                  isUpcoming: true, // Upcoming booking
                ),
              ),
            );
          },
          child: BookingCard(
            courtName: "StreetBall Club",
            date: "Tomorrow • 3:30 PM",
            duration: "1.5 hours",
            price: "\$30",
            image: 'lib/assets/images/venues/basketball.jpeg',
          ),
        ),
      ],
    );
  }

  Widget _buildPreviousBookings() {
    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingInfoPage(
                  courtName: "City Sports Arena",
                  date: "March 5 • 6:00 PM",
                  duration: "2 hours",
                  price: "\$50",
                  image: 'lib/assets/images/venues/padel.jpg',
                  isUpcoming: false, // Past booking
                ),
              ),
            );
          },
          child: BookingCard(
            courtName: "City Sports Arena",
            date: "March 5 • 6:00 PM",
            duration: "2 hours",
            price: "\$50",
            image: 'lib/assets/images/venues/padel.jpg',
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingInfoPage(
                  courtName: "Elite Club",
                  date: "March 3 • 5:00 PM",
                  duration: "1 hour",
                  price: "\$25",
                  image: 'lib/assets/images/venues/football.jpg',
                  isUpcoming: false,
                ),
              ),
            );
          },
          child: BookingCard(
            courtName: "Elite Club",
            date: "March 3 • 5:00 PM",
            duration: "1 hour",
            price: "\$25",
            image: 'lib/assets/images/venues/football.jpg',
          ),
        ),
      ],
    );
  }
}

PreferredSizeWidget _buildAppBar(
    BuildContext context, Function(int) onBackPressed) {
  final isIos = Platform.isIOS;

  return AppBar(
    title: Text(
      'My Bookings',
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
    leading: IconButton(
      onPressed: () {
        onBackPressed(0);
      },
      icon: Icon(isIos ? Icons.arrow_back_ios_new : Icons.arrow_back),
    ),
  );
}
