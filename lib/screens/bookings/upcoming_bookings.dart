import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time4play/models/booking.dart';
import 'package:time4play/providers/user_bookings_provider.dart';
import 'package:time4play/screens/bookings/booking_info.dart';
import 'package:time4play/services/company_service.dart';
import 'package:time4play/services/court_service.dart';
import 'package:time4play/services/sport_service.dart';
import 'package:time4play/widgets/upcoming_bookings/booking_card.dart';

class UpcomingBookingsScreen extends ConsumerStatefulWidget {
  const UpcomingBookingsScreen({
    super.key,
    required this.switchScreen,
  });

  final void Function(int) switchScreen;

  @override
  ConsumerState<UpcomingBookingsScreen> createState() =>
      _UpcomingBookingsScreenState();
}

class _UpcomingBookingsScreenState extends ConsumerState<UpcomingBookingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _settingsController;
  late Animation<double> _settingsFadeAnimation;
  late TabController _tabController;
  int _currentIndex = 0;

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

  Future<Sport> _getSportById(String sportId) async {
    return await FirestoreSportService.getSportById(sportId) ??
        Sport(
          id: '',
          name: '',
          description: '',
          pricePerHour: 0,
          companyId: '',
        );
  }

  Future<Company> _getCompanyById(String companyId) async {
    return await FirestoreCompanyService.getCompanyById(companyId);
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(userBookingsProvider);
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: _buildAppBar(context, widget.switchScreen),
      body: SafeArea(
        child: bookingsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (err, _) => Center(child: Text("Error: $err")),
          data: (bookings) {
            final userBookings = bookings
                .where((booking) => booking.customerId == user?.uid)
                .toList();
            final upComing = userBookings
                .where(
                  (booking) => booking.startTime.isAfter(
                    DateTime.now(),
                  ),
                )
                .toList()
              ..sort((a, b) => a.startTime.compareTo(b.startTime));

            final previous = userBookings
                .where(
                  (booking) => booking.startTime.isBefore(
                    DateTime.now(),
                  ),
                )
                .toList()
              ..sort((a, b) => b.startTime.compareTo(a.startTime));

            return Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  dividerColor: Colors.transparent,
                  tabs: const [
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
                        _buildBookingList(upComing, true),
                        _buildBookingList(previous, false),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings, bool isUpcoming) {
    final isBookingEmpty = bookings.isEmpty;

    if (isBookingEmpty) {
      return Center(
        child: Text(
          isUpcoming ? 'No Upcoming Matches' : 'No Previous Matches',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    return ListView.builder(
      itemCount: bookings.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final booking = bookings[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: FutureBuilder<Sport>(
            future: _getSportById(booking.sportId),
            builder: (context, sportSnapshot) {
              if (!sportSnapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final sport = sportSnapshot.data!;
              return FutureBuilder<Company>(
                future: _getCompanyById(sport.companyId),
                builder: (context, companySnapshot) {
                  if (!companySnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final company = companySnapshot.data!;
                  return GestureDetector(
                    onTap: () async {
                      final court = await FirestoreCourtService.getCourtById(
                              booking.courtId) ??
                          Court(
                            id: '',
                            name: '',
                            companyId: '',
                            sportId: '',
                            isIndoor: false,
                          );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingInfoPage(
                            courtName: court.name,
                            startTime: booking.startTime.toString(),
                            duration: "${booking.duration} minutes",
                            price:
                                "\$${sport.pricePerHour * booking.duration / 60}",
                            image: 'lib/assets/images/venues/football.jpg',
                            isUpcoming: isUpcoming,
                            companyName: company.name,
                            booking: booking,
                          ),
                        ),
                      );
                    },
                    child: BookingCard(
                      companyName: company.name,
                      date: booking.startTime.toString(),
                      duration: "${booking.duration} minutes",
                      price: "\$${sport.pricePerHour * booking.duration / 60}",
                      image: 'lib/assets/images/venues/football.jpg',
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

PreferredSizeWidget _buildAppBar(
    BuildContext context, Function(int) onBackPressed) {
  final isIos = Platform.isIOS;

  return AppBar(
    surfaceTintColor: Colors.transparent,
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
