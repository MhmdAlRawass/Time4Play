import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:time4play/models/booking.dart';
import 'package:time4play/screens/venues/checkout.dart';
import 'package:time4play/services/booking_service.dart';
import 'package:time4play/services/court_service.dart';
import 'package:time4play/widgets/alert_overlay.dart';
import 'package:time4play/widgets/booking/available_court_card.dart';
import 'dart:io' show Platform;
import 'package:time4play/widgets/booking/date_card.dart';
import 'package:time4play/widgets/booking/session_duration.dart';
import 'package:time4play/widgets/booking/time_slot_card.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({
    super.key,
    required this.imageUrl,
    required this.company,
    required this.sport,
  });

  final String imageUrl;
  final Company company;
  final Sport sport;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextStyle textStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  bool _isExpanded = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _expandedKey = GlobalKey();
  DateTime? _selectedDate;
  DateTime? _selectedTime;
  bool _isLoading = false;
  Set<DateTime> _bookedSlots = {};

  // Define the court's operating hours.
  final TimeOfDay openingTime = const TimeOfDay(hour: 8, minute: 0);
  // Adjusted closing time since TimeOfDay hour should be between 0-23.
  final TimeOfDay closingTime = const TimeOfDay(hour: 23, minute: 59);

  // Define the session duration (in minutes).
  int sessionDurationMinutes = 60;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadBookedSlots(_selectedDate ?? DateTime.now());
  }

  /// Generates time slots for the given [date] based on the court's operating hours.
  List<DateTime> _generateTimeSlots(DateTime date) {
    final DateTime openingDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      openingTime.hour,
      openingTime.minute,
    );
    final DateTime closingDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      closingTime.hour,
      closingTime.minute,
    );

    List<DateTime> slots = [];
    DateTime slot = openingDateTime;

    // Generate slots until reaching midnight (12 AM)
    while (slot.isBefore(closingDateTime)) {
      slots.add(slot);
      slot = slot.add(const Duration(minutes: 30));
    }

    return slots;
  }

  List<Court> _availableCourts = [];

  void _toggleExpanded() async {
    if (_selectedTime == null) return;

    setState(() {
      _isLoading = true;
    });
    final courts = await _getAvailableCourts(_selectedTime!);

    setState(() {
      _isLoading = false;
      _availableCourts = courts;
      _isExpanded = true;
      _clickAnimationTimer();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_expandedKey.currentContext != null) {
        Scrollable.ensureVisible(
          _expandedKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _filteredTimeSlots() {
    final now = DateTime.now();

    // Generate all time slots for the selected date
    final allSlots = _generateTimeSlots(_selectedDate ?? DateTime.now());

    // Mark all slots before the current time as "booked"
    final filteredSlots = allSlots.where((slot) {
      return !slot.isBefore(now) && !_bookedSlots.contains(slot);
    }).toList();

    // Update the UI with the filtered slots
    setState(() {
      _bookedSlots = filteredSlots.toSet();
    });
  }

  Future<List<Court>> _getAvailableCourts(DateTime selectedStartTime) async {
    final courts =
        await FirestoreCourtService.getCourtForSport(widget.sport.id);

    // Get bookings that might overlap with selected time
    final bookingSnapshot = await FirebaseFirestore.instance
        .collection('booking')
        .where('sportId', isEqualTo: widget.sport.id)
        .get();

    final selectedEndTime =
        selectedStartTime.add(Duration(minutes: sessionDurationMinutes));

    final bookedCourtIds = bookingSnapshot.docs
        .where((doc) {
          final bookingData = doc.data();
          final startTime = (bookingData['startTime'] as Timestamp).toDate();
          final duration = bookingData['duration'] as int;
          final endTime = startTime.add(Duration(minutes: duration));

          // Check if time ranges overlap
          final isOverlapping = selectedStartTime.isBefore(endTime) &&
              selectedEndTime.isAfter(startTime);

          return isOverlapping;
        })
        .map((doc) => doc['courtId'] as String)
        .toSet();

    final availableCourts =
        courts.where((court) => !bookedCourtIds.contains(court.id)).toList();

    return availableCourts;
  }

  Future<void> _loadBookedSlots(DateTime day) async {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    setState(() {
      _isLoading = true;
    });

    // Fetch all courts for the sport
    final courts =
        await FirestoreCourtService.getCourtForSport(widget.sport.id);
    final courtCount = courts.length;

    // Fetch all bookings for the sport
    final bookings =
        await FirestoreBookingService.getBookingsForSport(widget.sport.id);

    // Generate all 30-minute slots for the selected day
    final slots = _generateTimeSlots(day);

    // Mapping: slot -> Set of courts booked at that time
    final Map<DateTime, Set<String>> slotCourtMap = {};

    for (var booking in bookings) {
      final start = booking.startTime;
      final end = start.add(Duration(minutes: booking.duration));

      // Only consider bookings on this day
      if (start.isBefore(endOfDay) && end.isAfter(startOfDay)) {
        DateTime slot = DateTime(
          start.year,
          start.month,
          start.day,
          start.hour,
          start.minute,
        );

        while (slot.isBefore(end)) {
          slotCourtMap.putIfAbsent(slot, () => {}).add(booking.courtId);
          slot = slot.add(const Duration(minutes: 30));
        }
      }
    }

    // Mark slot as "booked" only if all courts are already booked for it
    final Set<DateTime> fullyBookedSlots = slots.where((slot) {
      final bookedCourts = slotCourtMap[slot];
      return bookedCourts != null && bookedCourts.length >= courtCount;
    }).toSet();

    setState(() {
      _bookedSlots = fullyBookedSlots;
      _isLoading = false;
    });
  }

  void _onPressedConfirmBooking() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final docRef = FirebaseFirestore.instance.collection('booking').doc();

      final newBooking = Booking(
        id: docRef.id,
        customerId: FirebaseAuth.instance.currentUser!.uid,
        sportId: widget.sport.id,
        courtId: _availableCourts.first.id,
        startTime: _selectedTime!,
        duration: sessionDurationMinutes,
        createdAt: DateTime.now(),
      );

      await FirestoreBookingService.createBooking(newBooking);

      AlertOverlay.show(
        context,
        "Booking Confirmed.",
        isError: false,
        duration: const Duration(seconds: 3),
      );

      setState(() {
        _isLoading = false;
        _selectedTime = null;
        _isExpanded = false;
        _availableCourts.clear();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AlertOverlay.show(
        context,
        "Failed to Confirm Booking.",
        duration: const Duration(seconds: 3),
      );
    }
  }

  bool _showAnimation = false;

  void _clickAnimationTimer() async {
    if (_isExpanded) {
      setState(() {
        _showAnimation = true;
      });

      await Future.delayed(const Duration(seconds: 10), () {
        setState(() {
          _showAnimation = false;
        });
      });
    }
    setState(() {
      _showAnimation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use the selected date, or default to today.
    final DateTime dateForSlots = _selectedDate ?? DateTime.now();

    // Generate all 30-minute time slots for the selected day
    final List<DateTime> timeSlots = _generateTimeSlots(dateForSlots);
    final now = DateTime.now();

    return Stack(
      children: [
        Scaffold(
          appBar: _buildAppBar(context,
              imageUrl: widget.imageUrl, company: widget.company),
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.4),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dates section.
                    Text('Dates', style: textStyle),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          final DateTime date =
                              DateTime.now().add(Duration(days: index));
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _selectedDate = date;
                                  _isExpanded = false;
                                  _selectedTime = null;
                                });

                                await _loadBookedSlots(date);
                              },
                              child: DateCard(
                                date: date,
                                selectedDate: _selectedDate ?? DateTime.now(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Divider.
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Session Duration section.
                    Text('Session Duration', style: textStyle),
                    const SizedBox(height: 12),
                    SessionDuration(
                      onPressedDuration: (value) {
                        setState(() {
                          sessionDurationMinutes = value;
                          _isExpanded = false;
                          _selectedTime = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    // Starting Time section.
                    Text('Starting Time', style: textStyle),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 6.0,
                      children: timeSlots.map((timeSlot) {
                        final isPast = timeSlot.isBefore(now);
                        return GestureDetector(
                          onTap: isPast || _bookedSlots.contains(timeSlot)
                              ? null
                              : () {
                                  setState(() {
                                    _selectedTime = timeSlot;
                                  });
                                  _toggleExpanded();
                                },
                          child: TimeSlotCard(
                            date: timeSlot,
                            selectedTime: _selectedTime ?? DateTime.now(),
                            isBooked: isPast || _bookedSlots.contains(timeSlot),
                          ),
                        );
                      }).toList(),
                    ),
                    if (_isExpanded) const SizedBox(height: 18),
                    if (_isExpanded)
                      Container(
                        key: _expandedKey,
                        width: double.infinity,
                        height: 1,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    if (_isExpanded) const SizedBox(height: 12),
                    if (_isExpanded) Text('Available Courts', style: textStyle),
                    if (_isExpanded) const SizedBox(height: 12),
                    if (_isExpanded && _selectedTime != null)
                      ListView.builder(
                        itemCount: _availableCourts.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final court = _availableCourts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Stack(
                              children: [
                                AvailableCourtCard(
                                  court: court,
                                  timeSlot: _selectedTime!,
                                  selectedDuration: sessionDurationMinutes,
                                  onTap: () {
                                    // You could pass selected court + time to checkout here
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => CheckOutScreen(
                                          courtName: court.name,
                                          company: widget.company,
                                          duration: sessionDurationMinutes,
                                          sport: widget.sport,
                                          startTime: _selectedTime!,
                                          onPressedConfirm: () {
                                            _onPressedConfirmBooking();
                                            setState(() {
                                              _loadBookedSlots(_selectedDate!);
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  sport: widget.sport,
                                ),
                                if (_showAnimation)
                                  Positioned(
                                    right: 0,
                                    bottom: -10,
                                    child: Lottie.asset(
                                      'lib/assets/animations/click.json',
                                      width: 50,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    if (_isExpanded && _availableCourts.isEmpty)
                      Center(
                        child: Text(
                          'No available courts for this time slot.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context,
    {required String imageUrl, required Company company}) {
  final size = MediaQuery.of(context).size;
  return PreferredSize(
    preferredSize: Size.fromHeight(size.height * 0.27),
    child: Stack(
      children: [
        Hero(
          tag: imageUrl,
          transitionOnUserGestures: true,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 42,
          left: 8,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios_new : Icons.arrow_back,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12).copyWith(
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${company.name} - ${company.address}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      company.city,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton.filled(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.location_on_outlined),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
