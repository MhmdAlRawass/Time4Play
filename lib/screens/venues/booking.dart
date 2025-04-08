import 'package:flutter/material.dart';
import 'package:time4play/screens/venues/checkout.dart';
import 'package:time4play/widgets/booking/available_court_card.dart';
import 'dart:io' show Platform;
import 'package:time4play/widgets/booking/date_card.dart';
import 'package:time4play/widgets/booking/session_duration.dart';
import 'package:time4play/widgets/booking/time_slot_card.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

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
    // Generate slots until reaching the closing time.
    while (slot.isBefore(closingDateTime)) {
      slots.add(slot);
      // Adjust the increment as needed (here it is 30 minutes).
      slot = slot.add(const Duration(minutes: 30));
    }
    return slots;
  }

  /// Expands the lower part of the view to show available courts.
  void _toggleExpanded() {
    setState(() {
      _isExpanded = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isExpanded && _expandedKey.currentContext != null) {
        Scrollable.ensureVisible(
          _expandedKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void navigateToCheckOut() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => CheckOutScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use the selected date, or default to today.
    final DateTime dateForSlots = _selectedDate ?? DateTime.now();
    final List<DateTime> timeSlots = _generateTimeSlots(dateForSlots);

    return Scaffold(
      appBar: _buildAppBar(context),
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
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
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
                          onTap: () {
                            setState(() {
                              _selectedDate = date;
                              _isExpanded = false;
                              _selectedTime = null;
                            });
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
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTime = timeSlot;
                        });
                        _toggleExpanded();
                      },
                      child: TimeSlotCard(
                        date: timeSlot,
                        selectedTime: _selectedTime ?? DateTime.now(),
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
                  InkWell(
                    onTap: () {
                      navigateToCheckOut();
                    },
                    child: AvailableCourtCard(
                      selectedDuration: sessionDurationMinutes,
                      timeSlot: _selectedTime!,
                      courtName: 'Court 1',
                      isIndoor: false,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return PreferredSize(
    preferredSize: Size.fromHeight(size.height * 0.27),
    child: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/images/venues/basketball.jpeg'),
              fit: BoxFit.cover,
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
                  children: const [
                    Text(
                      'The Padelist - Saida',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Saida, Lebanon',
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
