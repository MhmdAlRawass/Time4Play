import 'package:flutter/material.dart';
import 'package:time4play/models/booking.dart';
import 'package:time4play/services/booking_service.dart';
import 'package:time4play/widgets/alert_overlay.dart';

class BookingInfoPage extends StatelessWidget {
  final String companyName;
  final String startTime;
  final String duration;
  final Booking booking;
  final String courtName;
  final String price;
  final String image;
  final bool isUpcoming;

  const BookingInfoPage({
    super.key,
    required this.companyName,
    required this.startTime,
    required this.duration,
    required this.price,
    required this.image,
    required this.isUpcoming,
    required this.booking,
    required this.courtName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.primary.withAlpha(80);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: borderColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.calendar_today_outlined, startTime),
                    const SizedBox(height: 10),
                    _buildInfoRowCustomIcon(
                        ImageIcon(
                          AssetImage('lib/assets/icons/venue.png'),
                          color: Colors.grey[600],
                          size: 24,
                        ),
                        courtName),
                    const SizedBox(height: 10),
                    _buildInfoRow(Icons.access_time_outlined, duration),
                    const SizedBox(height: 10),
                    _buildInfoRow(Icons.attach_money, price),
                  ],
                ),
              ),
            ),
            if (isUpcoming)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _showCancelDialog(context),
                    icon: const Icon(Icons.cancel),
                    label: const Text(
                      'Cancel Booking',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowCustomIcon(Widget icon, String text) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              await FirestoreBookingService.removeBooking(booking.id);
              Navigator.pop(context);
              Navigator.pop(context);
              AlertOverlay.show(
                context,
                'Booking Cancelled',
              );
            },
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
