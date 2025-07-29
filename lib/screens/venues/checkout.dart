import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time4play/models/booking.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({
    super.key,
    required this.courtName,
    required this.startTime,
    required this.duration,
    required this.company,
    required this.sport,
    required this.onPressedConfirm,
  });

  final String courtName;
  final DateTime startTime;
  final int duration;
  final Company company;
  final Sport sport;

  final Function() onPressedConfirm;

  @override
  Widget build(BuildContext context) {
    final endTime = startTime.add(Duration(minutes: duration));
    final startTimeFormatted = DateFormat('HH:mm').format(startTime);
    final endTimeFormatted = DateFormat('HH:mm').format(endTime);
    final timeRange = '$startTimeFormatted - $endTimeFormatted';
    final finalPrice = sport.pricePerHour * duration / 60;
    final matchDate = DateFormat('EEEE, d MMMM').format(startTime);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Summary card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.cardColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Booking',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Date & Time
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            matchDate,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time_filled,
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black54,
                              size: 20),
                          const SizedBox(width: 10),
                          Text(
                            timeRange,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Location
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on,
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black54,
                              size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${company.name}, ${company.address}',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Court & Sport
                      Row(
                        children: [
                          Icon(Icons.sports_tennis,
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black54,
                              size: 20),
                          const SizedBox(width: 10),
                          Text(
                            '${sport.name} at $courtName',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Price
                      Divider(
                        color: isDarkMode ? Colors.white24 : Colors.black26,
                        thickness: 1,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white60 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${finalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Confirm Booking Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog.adaptive(
                          title: Text('Confirm Booking'),
                          content: Text(
                              'Are you sure you want to confirm this booking?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                onPressedConfirm();
                              },
                              child: Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline,
                      color: Colors.white),
                  label: Text(
                    'Confirm Booking',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
}
