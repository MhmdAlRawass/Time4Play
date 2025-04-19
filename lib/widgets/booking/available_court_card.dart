import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time4play/widgets/gradient_border.dart';
import 'package:time4play/models/booking.dart'; // assuming Court is in here

class AvailableCourtCard extends StatelessWidget {
  const AvailableCourtCard({
    super.key,
    required this.court,
    required this.timeSlot,
    required this.selectedDuration,
    this.onTap,
    required this.sport,
  });

  final Court court;
  final DateTime timeSlot;
  final int selectedDuration;
  final VoidCallback? onTap;
  final Sport sport;

  @override
  Widget build(BuildContext context) {
    final startTime = timeSlot;
    final endTime = timeSlot.add(Duration(minutes: selectedDuration));

    final startTimeFormatted = DateFormat('HH:mm').format(startTime);
    final endTimeFormatted = DateFormat('HH:mm').format(endTime);

    final textTimeFormatted = '$startTimeFormatted - $endTimeFormatted';
    final finalPrice = sport.pricePerHour * selectedDuration / 60;

    return GestureDetector(
      onTap: onTap,
      child: GradientBorderContainer(
        rightColor: Colors.redAccent,
        leftColor: const Color.fromARGB(255, 33, 40, 243),
        borderWidth: 2,
        child: Container(
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Court info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    court.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    court.isIndoor ? 'Indoor ☂️' : 'Outdoor ☀️',
                    style: const TextStyle(),
                  ),
                  Row(
                    children: [
                      Text(
                        textTimeFormatted,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($selectedDuration mins)',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Price info (static for now)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total Price',
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                  Text(
                    '\$ $finalPrice',
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
