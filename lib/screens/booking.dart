import 'package:flutter/material.dart';
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
  final textStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  bool _isExpanded = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _expandedKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isExpanded) {
        if (_expandedKey.currentContext != null) {
          Scrollable.ensureVisible(
            _expandedKey.currentContext!,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } else {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                Text(
                  'Dates',
                  style: textStyle,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: DateCard(
                          date: DateTime.now().add(Duration(days: index)),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 1,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Session Duration',
                  style: textStyle,
                ),
                const SizedBox(height: 12),
                SessionDuration(),
                const SizedBox(height: 12),
                Text(
                  'Starting Time',
                  style: textStyle,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 6.0,
                  children: List.generate(32, (index) {
                    return GestureDetector(
                      onTap: _toggleExpanded,
                      child: TimeSlotCard(
                        date: DateTime.now().add(
                          Duration(hours: index + 10),
                        ),
                      ),
                    );
                  }),
                ),
                if (_isExpanded) const SizedBox(height: 18),
                if (_isExpanded)
                  // The key here identifies the expanded section.
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
                if (_isExpanded)
                  Text(
                    'Available Courts',
                    style: textStyle,
                  ),
                if (_isExpanded) const SizedBox(height: 12),
                if (_isExpanded) const AvailableCourtCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: Size(double.infinity, 200),
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/basketball.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 42,
          left: 8,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios_new : Icons.arrow_back,
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
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The Padelist - Zalka',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Zalka, Lebanon',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton.filled(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.primary),
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
